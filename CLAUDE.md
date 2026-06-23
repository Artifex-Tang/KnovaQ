# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**知枢 · KnovaQ** — multi-customer deployment platform combining ragflow 0.18.0 full with gaisoft-mes (Spring Boot) and gaisoft-ui (Vue 3). Source for gaisoft-mes and gaisoft-ui lives in sibling directories at `E:/ccode/gaisoft-mes` and `E:/ccode/gaisoft-ui`.

## Common Commands

Deployment targets Linux (Ubuntu). Run the bash scripts in `docker/scripts/`:
```bash
./docker/scripts/start.sh demo          # Start customer environment (omit arg for default project)
./docker/scripts/stop.sh                # Stop all services
./docker/scripts/build-mes.sh demo      # Update backend jar
./docker/scripts/build-ui.sh demo       # Update frontend html
./docker/scripts/offline-save.sh        # Save images for offline delivery
./docker/scripts/offline-load.sh        # Load images on offline machine
```

> **Note:** After `git clone`, run `chmod +x docker/scripts/*.sh`.

## Adding a New Customer Project

```bash
cp -r docker/projects/_template docker/projects/<customer-name>
# Edit docker/projects/<customer-name>/.env     — ports, passwords
# Edit docker/projects/<customer-name>/nginx/default.conf — server_name, custom routes
git add docker/projects/<customer-name>/
git commit -m "feat: add <customer-name> project"
```

## Architecture

```
docker/
├── docker-compose.yml        ragflow 0.18.0 full + gaisoft-server + gaisoft-frontend
├── .env                      global defaults (image versions, default passwords/ports)
├── projects/<customer>/      per-customer .env overrides + nginx/default.conf
├── nginx/
│   ├── ragflow.conf          ragflow web UI + API proxy (mounted into ragflow container)
│   ├── nginx.conf            nginx main config (mounted into ragflow container)
│   ├── proxy.conf            proxy headers/timeouts (mounted into ragflow container)
│   └── default.conf          fallback — used when no project is specified
├── gaisoft/
│   ├── jar/gaisoftmes.jar    Spring Boot jar (updated by build-mes.sh)
│   ├── uploadfile/           persistent upload storage
│   └── nginx/                runtime nginx config, html, logs (for gaisoft-frontend)
├── init/
│   ├── ragflow-init.sql      creates rag_flow DB on every MySQL boot (--init-file)
│   └── equipment_iqas.sql    gaisoft-mes DB init (runs once on first MySQL boot)
└── scripts/                  start, stop, build, offline scripts
```

## Network

All services share the `ragflow` bridge network (Docker names it `docker_ragflow` because the compose lives in the `docker/` directory). gaisoft-server connects to ragflow-mysql:3306 and ragflow-redis:6379 using credentials from `.env`.

## DB Init Behavior

Two separate mechanisms:

- **`docker/init/ragflow-init.sql`** — mounted as MySQL's `--init-file`. Creates the `rag_flow` database on **every** MySQL startup (idempotent `CREATE DATABASE IF NOT EXISTS`).
- **`docker/init/equipment_iqas.sql`** — mounted in `/docker-entrypoint-initdb.d/`. MySQL runs it **once** when the data volume is first created, initializing the `equipment_iqas` schema. Re-running requires deleting the `mysql_data` Docker volume (`docker volume rm docker_mysql_data`), which destroys all data.

## gaisoft-server Environment (from gaisoft-mes config)

| Setting | Value |
|---------|-------|
| MySQL host | `ragflow-mysql:3306` |
| MySQL database | `equipment_iqas` |
| Redis host | `ragflow-redis:6379` |
| Redis database | `8` |
| Upload path | `/ragflow/uploadPath` (mounted from `gaisoft/uploadfile/`) |
