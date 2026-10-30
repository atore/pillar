# Pillar Sync Pro

Pillar Sync Pro è una soluzione enterprise-ready per la gestione di interventi edili multi-device, con sincronizzazione centralizzata tra master e slave, compatibile con Android, iPhone, Windows e Linux.

## Obiettivo

Creare un gestionale operativo per imprese edili con:
- dashboard condivisa
- gestione cantieri e commesse
- materiali e magazzino
- documenti e foto di cantiere
- checklist sicurezza
- ruoli Master e Slave
- sincronizzazione offline-first
- queue di sincronizzazione
- autorizzazioni per reparto e sede centrale

## Architettura

- Backend: NestJS
- Database: PostgreSQL (ready for production)
- Cache & queue: Redis
- Frontend: Flutter multipiattaforma
- Local storage: SQLite / SharedPreferences
- Autenticazione: JWT + ruolo
- Sync: eventi centralizzati + approvazione master

## Ruoli

### Master
- legge tutto
- approva tutte le modifiche
- pubblica aggiornamenti condivisi
- riceve dati da tutti i device autorizzati

### Slave
- invia dati dal cantiere o dal reparto
- riceve solo ciò che gli è stato assegnato
- non può sovrascrivere la vera sorgente di dati
- opera in modalita offline-first

## Struttura del progetto

- `apps/server` – API backend
- `apps/flutter_app` – app multipiattaforma
- `docker-compose.yml` – PostgreSQL + Redis
- `.env.example` – variabili ambiente

## Avvio rapido

### 1. Database e cache

```bash
docker compose up -d
```

### 2. Backend

```bash
cd apps/server
npm install
npm run start:dev
```

### 3. App Flutter

```bash
cd apps/flutter_app
flutter pub get
flutter run
```

## Login demo

- Master: `admin@pillar.it` / `pillar123`
- Slave: `cantiere@pillar.it` / `pillar123`

## Stato attuale

Il progetto contiene:
- backend centralizzato con API demo
- app Flutter con login, dashboard, sincronizzazione e queue
- modello master/slave real-world
- struttura pronta per estensione con database reale e moduli avanzati

## Prossimi sviluppi

- autenticazione JWT reale
- database PostgreSQL completo
- entities per cantieri, materiali, documenti, checklist
- sincronizzazione con versionamento e conflitti
- componenti mobile/desktop avanzati
- file upload e foto di cantiere

Questo repo è pronto per diventare un gestionale completo di produzione per imprese edili.
