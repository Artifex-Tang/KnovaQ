#!/usr/bin/env bash
# =============================================================================
# KnovaQ 离线补丁 — 开发机打包脚本
# 用法:
#   ./patch-pack.sh [--mes-dir DIR] [--ui-dir DIR] [--output-dir DIR] [--no-build]
# =============================================================================
set -euo pipefail

# ── 颜色输出 ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log_info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_step()  { echo -e "${CYAN}[STEP]${NC}  $*"; }
die()       { log_error "$@"; exit 1; }

# ── 目录发现 ──────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$DOCKER_DIR/.." && pwd)"

# ── 默认值 ───────────────────────────────────────────────────────────────────
MES_DIR="$REPO_ROOT/../gaisoft-mes"
UI_DIR="$REPO_ROOT/../gaisoft-ui"
OUTPUT_DIR="$DOCKER_DIR"
NO_BUILD=false

# ── 参数解析 ─────────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --mes-dir)     MES_DIR="$2"; shift 2 ;;
    --ui-dir)      UI_DIR="$2"; shift 2 ;;
    --output-dir)  OUTPUT_DIR="$2"; shift 2 ;;
    --no-build)    NO_BUILD=true; shift ;;
    -h|--help)
      cat <<'EOF'
KnovaQ 离线补丁打包工具

用法:
  ./patch-pack.sh [选项]

选项:
  --mes-dir DIR     gaisoft-mes 源码目录 (默认: ../gaisoft-mes)
  --ui-dir DIR      gaisoft-ui 源码目录 (默认: ../gaisoft-ui)
  --output-dir DIR  输出目录 (默认: docker/)
  --no-build        跳过构建，使用已有产物
  -h, --help        显示帮助
EOF
      exit 0 ;;
    *) die "未知参数: $1" ;;
  esac
done

# 转为绝对路径
MES_DIR="$(cd "$MES_DIR" 2>/dev/null && pwd)" || die "MES目录不存在: $MES_DIR"
UI_DIR="$(cd "$UI_DIR" 2>/dev/null && pwd)" || die "UI目录不存在: $UI_DIR"
OUTPUT_DIR="$(cd "$OUTPUT_DIR" 2>/dev/null && pwd)" || die "输出目录不存在: $OUTPUT_DIR"

# ── 校验目录 ─────────────────────────────────────────────────────────────────
validate_dirs() {
  [[ -f "$MES_DIR/pom.xml" ]] || die "MES目录缺少 pom.xml: $MES_DIR"
  [[ -f "$UI_DIR/package.json" ]] || die "UI目录缺少 package.json: $UI_DIR"
  [[ -f "$DOCKER_DIR/docker-compose.yml" ]] || die "缺少 docker-compose.yml: $DOCKER_DIR"
  log_info "MES: $MES_DIR"
  log_info "UI:  $UI_DIR"
}

# ── 构建前端 ─────────────────────────────────────────────────────────────────
build_frontend() {
  log_step "构建前端..."
  cd "$UI_DIR"
  if ! command -v npm &>/dev/null; then
    die "未找到 npm，请先安装 Node.js"
  fi
  npm run build:prod
  [[ -f "$UI_DIR/dist/index.html" ]] || die "前端构建失败: dist/index.html 不存在"
  local file_count
  file_count=$(find "$UI_DIR/dist" -type f | wc -l)
  log_info "前端构建完成: ${file_count} 文件"
}

# ── 构建后端 ─────────────────────────────────────────────────────────────────
build_backend() {
  log_step "构建后端..."
  cd "$MES_DIR"
  if ! command -v mvn &>/dev/null; then
    die "未找到 mvn，请先安装 Maven"
  fi
  mvn clean package -pl gaisoft-admin -am -DskipTests -q
  [[ -f "$MES_DIR/gaisoft-admin/target/gaisoftmes.jar" ]] || die "后端构建失败: jar 不存在"
  local jar_size
  jar_size=$(du -h "$MES_DIR/gaisoft-admin/target/gaisoftmes.jar" | cut -f1)
  log_info "后端构建完成: ${jar_size}"
}

# ── 收集 git 信息 ────────────────────────────────────────────────────────────
git_info() {
  local dir="$1"
  local commit branch
  commit=$(cd "$dir" && git rev-parse --short HEAD 2>/dev/null || echo "unknown")
  branch=$(cd "$dir" && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
  echo "{\"commit\":\"$commit\",\"branch\":\"$branch\"}"
}

# ── SHA256 计算 ──────────────────────────────────────────────────────────────
sha256_file() {
  if command -v sha256sum &>/dev/null; then
    sha256sum "$1" | cut -d' ' -f1
  elif command -v shasum &>/dev/null; then
    shasum -a 256 "$1" | cut -d' ' -f1
  else
    echo ""
  fi
}

# ── 生成 manifest.json ───────────────────────────────────────────────────────
generate_manifest() {
  local staging="$1"
  local timestamp
  timestamp=$(date +%Y%m%d-%H%M)
  local iso_time
  iso_time=$(date -Iseconds)

  local jar_size jar_hash
  jar_size=$(wc -c < "$staging/gaisoftmes.jar")
  jar_hash=$(sha256_file "$staging/gaisoftmes.jar")

  local html_count
  html_count=$(find "$staging/html" -type f | wc -l)

  local mes_git ui_git
  mes_git=$(git_info "$MES_DIR")
  ui_git=$(git_info "$UI_DIR")

  # nginx 文件 sha256
  local nginx_entries=""
  if [[ -d "$staging/nginx" ]]; then
    for conf in "$staging/nginx"/*.conf; do
      [[ -f "$conf" ]] || continue
      local name hash
      name=$(basename "$conf")
      hash=$(sha256_file "$conf")
      [[ -n "$nginx_entries" ]] && nginx_entries+=","
      nginx_entries+="\"$name\":{\"sha256\":\"$hash\"}"
    done
  fi

  cat > "$staging/manifest.json" <<EOFM
{
  "patch_version": "${timestamp}",
  "created_at": "${iso_time}",
  "mes_git": ${mes_git},
  "ui_git": ${ui_git},
  "files": {
    "gaisoftmes.jar": {"size": ${jar_size}, "sha256": "${jar_hash}"},
    "html/": {"count": ${html_count}}
    $([[ -n "$nginx_entries" ]] && echo ",\"nginx/\": {${nginx_entries}}")
  }
}
EOFM
  log_info "manifest.json 已生成"
}

# ── 组装 tarball ─────────────────────────────────────────────────────────────
assemble_tarball() {
  local timestamp
  timestamp=$(date +%Y%m%d-%H%M)
  local tarball="$OUTPUT_DIR/knovaq-patch-${timestamp}.tar.gz"

  local staging
  staging=$(mktemp -d /tmp/knovaq-patch-staging.XXXXXX)

  log_step "组装补丁包..."

  # 创建 staging 目录结构
  mkdir -p "$staging/patch/html" "$staging/patch/nginx"

  # 复制 jar
  cp "$MES_DIR/gaisoft-admin/target/gaisoftmes.jar" "$staging/patch/"
  log_info "已复制 gaisoftmes.jar"

  # 复制 html
  cp -a "$UI_DIR/dist/"* "$staging/patch/html/"
  log_info "已复制 html/"

  # 复制 nginx 配置（如存在）
  local nginx_dir="$DOCKER_DIR/nginx"
  if [[ -d "$nginx_dir" ]]; then
    for conf in "$nginx_dir"/*.conf; do
      [[ -f "$conf" ]] || continue
      cp "$conf" "$staging/patch/nginx/"
    done
    log_info "已复制 nginx 配置 ($(ls "$staging/patch/nginx"/*.conf 2>/dev/null | wc -l) 文件)"
  fi

  # 复制 patch-apply.sh
  cp "$SCRIPT_DIR/patch-apply.sh" "$staging/patch/"
  log_info "已包含 patch-apply.sh"

  # 生成 manifest
  generate_manifest "$staging/patch"

  # 打包
  tar -czf "$tarball" -C "$staging" patch/

  # 清理
  rm -rf "$staging"

  # 输出结果
  local tar_size
  tar_size=$(du -h "$tarball" | cut -f1)
  echo ""
  echo -e "${GREEN}══════════════════════════════════════════════${NC}"
  echo -e "${GREEN}  补丁包创建成功 ✓${NC}"
  echo -e "${GREEN}══════════════════════════════════════════════${NC}"
  echo "  文件: $tarball"
  echo "  大小: $tar_size"
  echo ""
  echo "  现场使用:"
  echo "    tar -xzf $(basename "$tarball")"
  echo "    bash patch/patch-apply.sh --docker-dir /path/to/docker"
  echo ""
}

# ── 主流程 ───────────────────────────────────────────────────────────────────
main() {
  echo ""
  echo -e "${CYAN}═══ KnovaQ 补丁打包工具 ═══${NC}"
  echo ""

  validate_dirs

  if [[ "$NO_BUILD" == "false" ]]; then
    build_frontend
    build_backend
  else
    log_warn "跳过构建 (--no-build)"
    # 校验已有产物
    [[ -f "$MES_DIR/gaisoft-admin/target/gaisoftmes.jar" ]] || die "jar 不存在: $MES_DIR/gaisoft-admin/target/gaisoftmes.jar"
    [[ -d "$UI_DIR/dist" ]] || die "dist 不存在: $UI_DIR/dist"
    log_info "使用已有产物"
  fi

  assemble_tarball
}

main
