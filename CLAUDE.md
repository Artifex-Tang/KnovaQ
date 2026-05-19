# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**知枢 · KnovaQ** — multi-customer deployment platform combining ragflow 0.18.0 full with gaisoft-mes (Spring Boot) and gaisoft-ui (Vue 3). Source for gaisoft-mes and gaisoft-ui lives in sibling directories at `E:/ccode/gaisoft-mes` and `E:/ccode/gaisoft-ui`.

## Common Commands

```bash
# Start a customer environment
./docker/scripts/start.sh demo

# Stop all services
./docker/scripts/stop.sh

# Update backend jar (after mvn build in gaisoft-mes)
./docker/scripts/build-mes.sh demo

# Update frontend html (after npm build in gaisoft-ui)
./docker/scripts/build-ui.sh demo

# Save all images for offline delivery
./docker/scripts/offline-save.sh

# Load images on offline customer machine
./docker/scripts/offline-load.sh
```

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
├── gaisoft/
│   ├── jar/gaisoftmes.jar    Spring Boot jar (updated by build-mes.sh)
│   ├── uploadfile/           persistent upload storage
│   └── nginx/                runtime nginx config, html, logs
├── init/
│   └── equipment_iqas.sql    gaisoft-mes DB init (runs once on first MySQL boot)
└── scripts/                  start, stop, build, offline scripts
```

## Network

All services share the `ragflow` bridge network (Docker names it `docker_ragflow` because the compose lives in the `docker/` directory). gaisoft-server connects to ragflow-mysql:3306 and ragflow-redis:6379 using credentials from `.env`.

## DB Init Behavior

`docker/init/equipment_iqas.sql` is mounted to MySQL's `/docker-entrypoint-initdb.d/`. MySQL runs it exactly once — when the data volume is first created. Re-running init requires deleting the `mysql_data` Docker volume (`docker volume rm docker_mysql_data`), which destroys all data.

## gaisoft-server Environment (from gaisoft-mes config)

| Setting | Value |
|---------|-------|
| MySQL host | `ragflow-mysql:3306` |
| MySQL database | `equipment_iqas` |
| Redis host | `ragflow-redis:6379` |
| Redis database | `8` |
| Upload path | `/ragflow/uploadPath` (mounted from `gaisoft/uploadfile/`) |
