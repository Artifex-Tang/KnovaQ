#!/usr/bin/env bash
# =============================================================================
# KnovaQ 离线补丁 — 现场升级/回滚脚本
# 用法:
#   bash patch-apply.sh [--docker-dir DIR] [--project NAME] [--dry-run]
#   bash patch-apply.sh --rollback [BACKUP_DIR]
#   bash patch-apply.sh --list-backups
# =============================================================================
set -euo pipefail

# ── 颜色输出 ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log_info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_step()  { echo -e "${CYAN}[STEP]${NC}  $*"; }
die()       { log_error "$@"; exit 1; }

# ── 参数解析 ──────────────────────────────────────────────────────────────────
DOCKER_DIR=""
PROJECT=""
ROLLBACK=""
LIST_BACKUPS=false
DRY_RUN=false
SKIP_VERIFY=false
FORCE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --docker-dir)   DOCKER_DIR="$2"; shift 2 ;;
    --project)      PROJECT="$2"; shift 2 ;;
    --rollback)     ROLLBACK="${2:-}"; shift $([[ -n "${2:-}" ]] && echo 2 || echo 1) ;;
    --list-backups) LIST_BACKUPS=true; shift ;;
    --dry-run)      DRY_RUN=true; shift ;;
    --skip-verify)  SKIP_VERIFY=true; shift ;;
    --force)        FORCE=true; shift ;;
    -h|--help)      usage ;;
    *) die "未知参数: $1" ;;
  esac
done

usage() {
  cat <<'EOF'
KnovaQ 离线补丁升级工具

用法:
  bash patch-apply.sh [选项]            # 应用补丁
  bash patch-apply.sh --rollback [DIR]  # 回滚到指定备份(默认最新)
  bash patch-apply.sh --list-backups    # 列出可用备份

选项:
  --docker-dir DIR    指定 docker/ 目录路径 (自动检测)
  --project NAME      客户项目名 (加载 projects/NAME/.env)
  --dry-run           只显示操作，不执行
  --skip-verify       跳过 sha256 校验
  --force             强制执行(跳过重复补丁检测)
  -h, --help          显示帮助
EOF
  exit 0
}

# ── compose 命令检测 ─────────────────────────────────────────────────────────
detect_compose_cmd() {
  if docker compose version &>/dev/null; then
    DC=(docker compose)
  elif command -v docker-compose &>/dev/null; then
    DC=(docker-compose)
  else
    die "未找到 docker compose 或 docker-compose，请先安装"
  fi
}

# ── 查找 docker/ 目录 ───────────────────────────────────────────────────────
find_docker_dir() {
  # 1. 命令行指定
  if [[ -n "$DOCKER_DIR" ]]; then
    [[ -f "$DOCKER_DIR/docker-compose.yml" ]] || die "指定目录未找到 docker-compose.yml: $DOCKER_DIR"
    return
  fi
  # 2. 从 PATCH_DIR 向上查找
  local dir="$PATCH_DIR"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/docker-compose.yml" ]]; then
      DOCKER_DIR="$dir"; return
    fi
    if [[ -f "$dir/docker/docker-compose.yml" ]]; then
      DOCKER_DIR="$dir/docker"; return
    fi
    dir="$(dirname "$dir")"
  done
  # 3. 常见位置
  for candidate in /opt/knovaq/docker /opt/knovaq /home/knovaq/docker; do
    if [[ -f "$candidate/docker-compose.yml" ]]; then
      DOCKER_DIR="$candidate"; return
    fi
  done
  die "未找到 docker-compose.yml，请用 --docker-dir 指定路径"
}

# ── 加载环境变量 ─────────────────────────────────────────────────────────────
load_env() {
  local env_file="$DOCKER_DIR/.env"
  [[ -f "$env_file" ]] || die "未找到 .env: $env_file"
  set -a; source "$env_file"; set +a
  log_info "COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME:-knovaq}"
  # 加载项目覆盖
  if [[ -n "$PROJECT" && -f "$DOCKER_DIR/projects/$PROJECT/.env" ]]; then
    set -a; source "$DOCKER_DIR/projects/$PROJECT/.env"; set +a
    log_info "加载项目配置: $PROJECT"
  fi
}

# ── 列出备份 ─────────────────────────────────────────────────────────────────
do_list_backups() {
  local backup_base="$DOCKER_DIR/backups"
  if [[ ! -d "$backup_base" ]]; then
    log_warn "无备份目录: $backup_base"; exit 0
  fi
  local count=$(find "$backup_base" -maxdepth 1 -name "backup-*" -type d | wc -l)
  if [[ "$count" -eq 0 ]]; then
    log_warn "无可用备份"; exit 0
  fi
  echo ""
  echo -e "${CYAN}可用备份 (${count}个):${NC}"
  echo "─────────────────────────────────────────────"
  for d in $(ls -d "$backup_base"/backup-* 2>/dev/null | sort -r); do
    local name=$(basename "$d")
    local ts=$(echo "$name" | sed 's/backup-//')
    local jar_size=""
    [[ -f "$d/gaisoftmes.jar" ]] && jar_size=$(du -h "$d/gaisoftmes.jar" | cut -f1)
    local html_count=""
    [[ -d "$d/html" ]] && html_count=$(find "$d/html" -type f | wc -l)
    echo "  $ts  jar=${jar_size:-无}  html=${html_count:-0}文件"
  done
  echo ""
}

# ── 回滚 ─────────────────────────────────────────────────────────────────────
do_rollback() {
  local backup_base="$DOCKER_DIR/backups"
  local backup_dir="$ROLLBACK"

  # 未指定则取最新
  if [[ -z "$backup_dir" ]]; then
    backup_dir=$(ls -d "$backup_base"/backup-* 2>/dev/null | sort -r | head -1)
    [[ -z "$backup_dir" ]] && die "无可用备份"
  fi
  # 补全相对路径
  if [[ ! "$backup_dir" = /* ]]; then
    backup_dir="$backup_base/$backup_dir"
  fi
  [[ -d "$backup_dir" ]] || die "备份目录不存在: $backup_dir"
  [[ -f "$backup_dir/gaisoftmes.jar" ]] || die "备份中缺少 gaisoftmes.jar"

  log_step "回滚自: $backup_dir"

  # 恢复 jar
  if [[ "$DRY_RUN" == "false" ]]; then
    cp "$backup_dir/gaisoftmes.jar" "$DOCKER_DIR/gaisoft/jar/gaisoftmes.jar"
    log_info "已恢复 jar"
  else
    log_info "[DRY-RUN] cp gaisoftmes.jar"
  fi

  # 恢复 html
  if [[ -d "$backup_dir/html" ]]; then
    if [[ "$DRY_RUN" == "false" ]]; then
      sync_html "$backup_dir/html" "$DOCKER_DIR/gaisoft/nginx/html"
      log_info "已恢复 html"
    else
      log_info "[DRY-RUN] 同步 html/"
    fi
  fi

  # 恢复 nginx 配置
  if [[ -f "$backup_dir/default.conf" ]]; then
    if [[ "$DRY_RUN" == "false" ]]; then
      cp "$backup_dir/default.conf" "$DOCKER_DIR/gaisoft/nginx/conf.d/default.conf" 2>/dev/null || true
      log_info "已恢复 nginx 配置"
    fi
  fi

  # 重启服务
  restart_services
  log_info "回滚完成 ✓"
}

# ── 同步 html ────────────────────────────────────────────────────────────────
sync_html() {
  local src="$1" dest="$2"
  if command -v rsync &>/dev/null; then
    rsync -a --delete --exclude .gitkeep "$src/" "$dest/"
  else
    # fallback: find+delete+cp (匹配 build-ui.sh 模式)
    find "$dest" -mindepth 1 -not -name '.gitkeep' -delete 2>/dev/null || true
    find "$dest" -mindepth 1 -type d -empty -delete 2>/dev/null || true
    cp -a "$src/"* "$dest/" 2>/dev/null || true
  fi
}

# ── 重启服务 ─────────────────────────────────────────────────────────────────
restart_services() {
  if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY-RUN] restart gaisoft-server"
    log_info "[DRY-RUN] reload gaisoft-frontend"
    return
  fi
  log_step "重启服务..."
  cd "$DOCKER_DIR"
  "${DC[@]}" restart gaisoft-server
  log_info "gaisoft-server 已重启"
  # nginx reload 优先，失败则 restart
  if ! "${DC[@]}" exec -T gaisoft-frontend nginx -s reload 2>/dev/null; then
    "${DC[@]}" restart gaisoft-frontend
    log_info "gaisoft-frontend 已重启"
  else
    log_info "gaisoft-frontend nginx 已 reload"
  fi
}

# ── 磁盘空间检查 ─────────────────────────────────────────────────────────────
check_disk_space() {
  local dir="$1"
  local avail_kb
  avail_kb=$(df "$dir" | awk 'NR==2{print $4}')
  local avail_mb=$((avail_kb / 1024))
  if [[ $avail_mb -lt 200 ]]; then
    die "磁盘空间不足: ${avail_mb}MB 可用 (需 ≥200MB)"
  fi
  log_info "磁盘空间: ${avail_mb}MB 可用"
}

# ── SHA256 校验 ──────────────────────────────────────────────────────────────
sha256_file() {
  if command -v sha256sum &>/dev/null; then
    sha256sum "$1" | cut -d' ' -f1
  elif command -v shasum &>/dev/null; then
    shasum -a 256 "$1" | cut -d' ' -f1
  else
    echo ""
  fi
}

# ── 备份当前版本 ─────────────────────────────────────────────────────────────
BACKUP_DIR=""  # global: set by do_backup
do_backup() {
  local backup_base="$DOCKER_DIR/backups"
  BACKUP_DIR="$backup_base/backup-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$BACKUP_DIR"

  log_step "备份当前版本 → $BACKUP_DIR"

  # 备份 jar
  if [[ -f "$DOCKER_DIR/gaisoft/jar/gaisoftmes.jar" ]]; then
    cp "$DOCKER_DIR/gaisoft/jar/gaisoftmes.jar" "$BACKUP_DIR/"
    log_info "已备份 gaisoftmes.jar"
  fi

  # 备份 html
  if [[ -d "$DOCKER_DIR/gaisoft/nginx/html" ]]; then
    cp -a "$DOCKER_DIR/gaisoft/nginx/html" "$BACKUP_DIR/html"
    log_info "已备份 html/"
  fi

  # 备份 nginx 配置
  if [[ -f "$DOCKER_DIR/gaisoft/nginx/conf.d/default.conf" ]]; then
    cp "$DOCKER_DIR/gaisoft/nginx/conf.d/default.conf" "$BACKUP_DIR/default.conf"
  fi

  # 写备份清单
  cat > "$BACKUP_DIR/backup-manifest.json" <<EOFM
{
  "backup_time": "$(date -Iseconds)",
  "jar_size": $(wc -c < "$BACKUP_DIR/gaisoftmes.jar" 2>/dev/null || echo 0),
  "patch_dir": "$PATCH_DIR"
}
EOFM
}

# ── 应用补丁 ─────────────────────────────────────────────────────────────────
do_apply() {
  local manifest="$PATCH_DIR/manifest.json"
  local jar_src="$PATCH_DIR/gaisoftmes.jar"
  local html_src="$PATCH_DIR/html"
  local nginx_src="$PATCH_DIR/nginx"

  # 1. 校验补丁完整性
  log_step "校验补丁..."
  [[ -f "$manifest" ]] || die "缺少 manifest.json"
  [[ -f "$jar_src" ]]  || die "缺少 gaisoftmes.jar"
  [[ -d "$html_src" ]] || die "缺少 html/ 目录"

  # sha256 校验
  if [[ "$SKIP_VERIFY" == "false" ]]; then
    local expected_hash
    expected_hash=$(python3 -c "import json; print(json.load(open('$manifest')).get('files',{}).get('gaisoftmes.jar',{}).get('sha256',''))" 2>/dev/null || true)
    if [[ -n "$expected_hash" ]]; then
      local actual_hash
      actual_hash=$(sha256_file "$jar_src")
      if [[ -n "$actual_hash" && "$actual_hash" != "$expected_hash" ]]; then
        die "jar sha256 不匹配!\n  期望: $expected_hash\n  实际: $actual_hash"
      fi
      log_info "sha256 校验通过"
    else
      log_warn "manifest 中无 sha256，跳过校验"
    fi

    # 重复补丁检测
    if [[ "$FORCE" == "false" && -f "$DOCKER_DIR/gaisoft/jar/gaisoftmes.jar" ]]; then
      local current_hash
      current_hash=$(sha256_file "$DOCKER_DIR/gaisoft/jar/gaisoftmes.jar")
      local new_hash
      new_hash=$(sha256_file "$jar_src")
      if [[ -n "$current_hash" && "$current_hash" == "$new_hash" ]]; then
        die "补丁jar与当前版本相同，如需强制执行请用 --force"
      fi
    fi
  fi

  # 2. 磁盘空间检查
  check_disk_space "$DOCKER_DIR"

  # 3. 备份
  if [[ "$DRY_RUN" == "false" ]]; then
    do_backup
  else
    BACKUP_DIR="[DRY-RUN] backup-YYYYMMDD-HHMMSS"
    log_info "[DRY-RUN] 备份当前版本"
  fi

  # 4. 应用
  log_step "应用补丁..."

  if [[ "$DRY_RUN" == "false" ]]; then
    # jar
    cp "$jar_src" "$DOCKER_DIR/gaisoft/jar/gaisoftmes.jar"
    log_info "已更新 gaisoftmes.jar ($(du -h "$jar_src" | cut -f1))"

    # html
    sync_html "$html_src" "$DOCKER_DIR/gaisoft/nginx/html"
    log_info "已更新 html/ ($(find "$html_src" -type f | wc -l) 文件)"

    # nginx 配置
    if [[ -d "$nginx_src" ]]; then
      for conf in "$nginx_src"/*.conf; do
        [[ -f "$conf" ]] || continue
        cp "$conf" "$DOCKER_DIR/nginx/$(basename "$conf")"
        log_info "已更新 nginx/$(basename "$conf")"
      done
    fi
  else
    log_info "[DRY-RUN] cp gaisoftmes.jar"
    log_info "[DRY-RUN] 同步 html/"
    log_info "[DRY-RUN] 复制 nginx 配置"
  fi

  # 5. 重启
  restart_services

  # 6. 输出结果
  echo ""
  echo -e "${GREEN}══════════════════════════════════════════════${NC}"
  echo -e "${GREEN}  补丁应用成功 ✓${NC}"
  echo -e "${GREEN}══════════════════════════════════════════════${NC}"
  if [[ "$DRY_RUN" == "false" ]]; then
    echo "  备份位置: $BACKUP_DIR"
    echo "  回滚命令: bash patch-apply.sh --rollback $BACKUP_DIR"
  fi
  echo ""
}

# ── 主流程 ───────────────────────────────────────────────────────────────────
main() {
  echo ""
  echo -e "${CYAN}═══ KnovaQ 离线补丁工具 ═══${NC}"
  echo ""

  # PATCH_DIR = 脚本所在目录 (解压后的 patch/)
  PATCH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  detect_compose_cmd
  find_docker_dir
  load_env

  cd "$DOCKER_DIR"

  if [[ "$LIST_BACKUPS" == "true" ]]; then
    do_list_backups
  elif [[ -n "$ROLLBACK" ]]; then
    do_rollback
  else
    do_apply
  fi
}

main
