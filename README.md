# Pillar

Pillar è una base real-world per un gestionale edile multi-device con architecture centralizzata master/slave.

## Requisiti

- Flutter 3.22+
- Node.js 20+
- Docker

## Avvio rapido

### 1) Backend

```bash
cd apps/server
npm install
npm run start:dev
```

### 2) Database

```bash
docker compose up -d
```

### 3) App Flutter

```bash
cd apps/flutter_app
flutter pub get
flutter run
```

## Login demo

- master: `admin@pillar.it` / `pillar123`
- slave: `cantiere@pillar.it` / `pillar123`

## Modalità

- Master: vede tutto, approva e distribuisce i dati.
- Slave: invia i dati e riceve solo quanto autorizzato.

## Importante

Questa versione è un starter completo per applicazione reale: login, dashboard, sincronizzazione e coda sync. È pronta per essere estesa con backend reale, database persistente e moduli di progetto.
