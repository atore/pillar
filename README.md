# Pillar

Pillar è un gestionale edile multi-device, pensato per funzionare su Android, iPhone, Windows e Linux con sincronizzazione centralizzata master/slave.

## Architettura

- Backend centralizzato: NestJS + PostgreSQL + Redis
- Frontend cross-platform: Flutter
- Offline-first: SQLite locale + sync queue
- Ruoli: Master e Slave
- Truth source: il master è l'unica sorgente di verità

## Struttura

- `apps/server`: backend API e sincronizzazione
- `apps/flutter_app`: app cross-platform
- `docker-compose.yml`: PostgreSQL + Redis
- `.env.example`: configurazione

## Requisiti

- Docker
- Node.js 20+
- Flutter 3.22+

## Avvio backend

```bash
cd apps/server
npm install
npm run start:dev
```

## Avvio database

```bash
docker compose up -d
```

## Avvio app Flutter

```bash
cd apps/flutter_app
flutter pub get
flutter run
```

## Ruoli

### Master
- legge tutto
- approva e distribuisce tutte le modifiche
- gestisce autorizzazioni e sincronizzazione

### Slave
- invia dati e foto
- riceve dati autorizzati
- non può sovrascrivere la verità del master

## Stato

Questa base è pronta per continuare con autenticazione reale, database, sincronizzazione e moduli funzionali di cantiere.
