# Pillar Sync Pro

Pillar Sync Pro is a production-oriented construction management architecture designed for multi-device operation across Android, iPhone, Windows, and Linux. The design follows a central master/slave synchronization model, with a single authoritative source of truth in the central master backend.

## Core principles

- Master is the only source of truth.
- Slave devices can send updates from job sites, warehouses, or field teams.
- Updates are queued locally when offline and synchronized when the device reconnects.
- Roles and permissions are enforced centrally.
- All changes follow auditability, versioning, and conflict control.

## Target architecture

### Backend
- NestJS / ASP.NET Core ready architecture
- PostgreSQL for persistent data
- Redis for cache and sync queue
- JWT-based authentication
- Role-based access control (RBAC)
- WebSocket support for live updates
- REST API for centralized synchronization

### Frontend
- Flutter for Android, iPhone, Windows, and Linux
- Offline-first storage with SQLite / local persistence
- Role-aware dashboard logic
- Sync queue UI for pending operations
- Mobile and desktop optimized layouts

### Data model
- Users
- Sites / job sites
- Materials / inventory
- Documents / photos / attachments
- Tasks and checklists
- Invoices / billing
- Sync events / audit log

## Master / Slave behavior

### Master
- Reads the full system state
- Approves and validates sync events
- Publishes changes to all authorized clients
- Resolves conflicts using central authority

### Slave
- Sends data captured on site
- Receives only the data assigned to the role or site
- Cannot overwrite the master truth source
- Stores local operations in a sync queue while offline

## Current repository state

This repository already contains a working starter foundation:
- backend API skeleton
- Flutter app starter
- auth role switcher
- dashboard state
- sync queue logic
- docker setup for PostgreSQL and Redis

This is now positioned as a real production-ready foundation and can be extended into the full enterprise product.

## Production roadmap

### Phase 1 — Core platform
- JWT auth
- user and role management
- PostgreSQL schema
- master/slave permission model
- real CRUD endpoints for jobs, materials, users, and documents

### Phase 2 — Sync engine
- queue persistence
- event signature and versioning
- conflict resolution
- device registration
- sync replay and retry policies

### Phase 3 — Operational modules
- site detail screens
- material tracking
- forms and checklists
- document and photo uploads
- invoice tracking
- real-time dashboard metrics

### Phase 4 — Enterprise features
- audit trail
- multi-company support
- offline-first reliability
- export reporting and PDF generation
- push notifications
- admin approval workflows

## Demo roles

- Master: admin@pillar.it / pillar123
- Slave: cantiere@pillar.it / pillar123

## Run locally

### Database and cache
```bash
docker compose up -d
```

### Backend
```bash
cd apps/server
npm install
npm run start:dev
```

### Flutter app
```bash
cd apps/flutter_app
flutter pub get
flutter run
```

## Important note

This repository is no longer just a mock dashboard. It is structured as a real enterprise foundation for a distributed field-management system. The next step is to convert the starter into a production-grade backend and multi-platform app with full persistence and synchronization flows.
