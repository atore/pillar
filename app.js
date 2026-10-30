* {
  box-sizing: border-box;
}

:root {
  --bg: #edf3fb;
  --bg-strong: #dfeaf7;
  --panel: #ffffff;
  --panel-alt: #f8fafc;
  --sidebar: #081b2d;
  --sidebar-soft: #112e49;
  --primary: #1e88e5;
  --primary-strong: #1565c0;
  --primary-soft: rgba(30, 136, 229, 0.12);
  --purple: #7c5cff;
  --purple-soft: rgba(124, 92, 255, 0.12);
  --success: #17a673;
  --success-soft: rgba(23, 166, 115, 0.12);
  --warning: #f0ad4e;
  --warning-soft: rgba(240, 173, 78, 0.12);
  --danger: #e85d5d;
  --danger-soft: rgba(232, 93, 93, 0.12);
  --text: #122033;
  --muted: #66768e;
  --line: #e6edf6;
  --shadow: 0 16px 30px rgba(17, 30, 45, 0.08);
  --radius: 20px;
}

html {
  scroll-behavior: smooth;
}

body {
  margin: 0;
  min-height: 100vh;
  font-family: "Inter", sans-serif;
  background: linear-gradient(135deg, #edf4ff 0%, #f7f9fe 100%);
  color: var(--text);
}

button,
input {
  font: inherit;
}

button {
  cursor: pointer;
}

.app-shell {
  display: grid;
  grid-template-columns: 260px 1fr;
  min-height: 100vh;
}

.sidebar {
  background: linear-gradient(180deg, var(--sidebar) 0%, var(--sidebar-soft) 100%);
  padding: 28px 20px 20px;
  display: flex;
  flex-direction: column;
  gap: 28px;
  color: #edf5ff;
}

.brand {
  display: flex;
  align-items: center;
  gap: 14px;
}

.logo {
  width: 44px;
  height: 44px;
  border-radius: 14px;
  display: grid;
  place-items: center;
  font-weight: 800;
  color: #082033;
  background: linear-gradient(135deg, #8ad8ff 0%, #1e88e5 100%);
  box-shadow: 0 12px 22px rgba(30, 136, 229, 0.35);
}

.brand h1 {
  margin: 0;
  font-size: 1.45rem;
}

.brand span {
  color: #b7cce8;
  font-size: 0.78rem;
}

.nav {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.nav a {
  color: #dfeaf8;
  text-decoration: none;
  padding: 12px 14px;
  border-radius: 12px;
  transition: all 0.2s ease;
}

.nav a:hover,
.nav a.active {
  background: rgba(255, 255, 255, 0.06);
  transform: translateX(3px);
}

.sidebar-card {
  margin-top: auto;
  background: rgba(255, 255, 255, 0.06);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 18px;
  padding: 18px 16px;
}

.sidebar-card p,
.sidebar-card span {
  margin: 0;
  color: #c9d9ef;
}

.sidebar-card strong {
  display: block;
  margin: 10px 0 6px;
  font-size: 2.1rem;
}

.main-content {
  padding: 28px;
}

.topbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  margin-bottom: 20px;
}

.search-wrap {
  display: flex;
  align-items: center;
  gap: 10px;
  background: rgba(255, 255, 255, 0.88);
  border: 1px solid var(--line);
  box-shadow: var(--shadow);
  border-radius: 14px;
  padding: 12px 16px;
  min-width: 340px;
  max-width: 520px;
  flex: 1;
}

.search-wrap span {
  font-size: 1.2rem;
  color: var(--muted);
}

.search-wrap input {
  width: 100%;
  border: none;
  outline: none;
  background: transparent;
  color: var(--muted);
}

.topbar-actions {
  display: flex;
  gap: 12px;
}

.ghost-btn,
.primary-btn,
.text-btn {
  border: none;
  border-radius: 12px;
  padding: 10px 16px;
  font-weight: 700;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.ghost-btn {
  background: var(--panel);
  color: var(--text);
  box-shadow: var(--shadow);
}

.primary-btn {
  background: linear-gradient(135deg, var(--primary) 0%, var(--primary-strong) 100%);
  color: white;
  box-shadow: 0 12px 26px rgba(30, 136, 229, 0.22);
}

.ghost-btn:hover,
.primary-btn:hover,
.text-btn:hover {
  transform: translateY(-1px);
}

.overview-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  margin-bottom: 22px;
}

.eyebrow {
  margin: 0 0 6px;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  color: var(--muted);
  font-weight: 700;
  font-size: 0.72rem;
}

.overview-head h2 {
  margin: 0;
  font-size: clamp(2rem, 2.5vw, 2.6rem);
}

.date-pill {
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid var(--line);
  border-radius: 999px;
  padding: 10px 16px;
  color: var(--muted);
  font-weight: 600;
  box-shadow: var(--shadow);
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 18px;
  margin-bottom: 22px;
}

.stat-card {
  background: rgba(255, 255, 255, 0.94);
  border: 1px solid rgba(230, 237, 246, 0.9);
  border-radius: var(--radius);
  padding: 18px 18px 16px;
  box-shadow: var(--shadow);
}

.stat-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 18px;
}

.stat-card h4 {
  margin: 0;
  font-size: 0.8rem;
  font-weight: 700;
  color: var(--muted);
}

.stat-icon {
  width: 42px;
  height: 42px;
  border-radius: 12px;
  display: grid;
  place-items: center;
  color: white;
  font-size: 1.2rem;
}

.stat-value {
  margin: 0;
  font-size: clamp(1.7rem, 2vw, 2.2rem);
  font-weight: 800;
}

.stat-trend {
  display: inline-block;
  margin-top: 10px;
  border-radius: 999px;
  padding: 6px 10px;
  font-size: 0.72rem;
  font-weight: 800;
}

.positive {
  background: var(--success-soft);
  color: var(--success);
}

.warning {
  background: var(--warning-soft);
  color: #c98b2d;
}

.content-grid {
  display: grid;
  grid-template-columns: 1.7fr 1fr;
  gap: 20px;
  margin-bottom: 20px;
}

.panel {
  background: rgba(255, 255, 255, 0.96);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  padding: 20px;
  box-shadow: var(--shadow);
}

.panel-large {
  min-height: 300px;
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  margin-bottom: 18px;
}

.panel-header h3 {
  margin: 0;
  font-size: 1.1rem;
}

.text-btn {
  background: transparent;
  color: var(--primary-strong);
  padding: 0;
}

.chart-wrapper {
  display: grid;
  gap: 18px;
}

.chart-legend {
  display: flex;
  gap: 18px;
  flex-wrap: wrap;
  color: var(--muted);
  font-size: 0.82rem;
}

.legend-dot {
  display: inline-block;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  margin-right: 8px;
}

.legend-dot.primary {
  background: var(--primary);
}

.legend-dot.purple {
  background: var(--purple);
}

.chart-bars {
  display: grid;
  grid-template-columns: repeat(6, minmax(0, 1fr));
  align-items: end;
  gap: 18px;
  height: 170px;
  padding-top: 10px;
}

.bar-column {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: end;
  gap: 10px;
  height: 100%;
}

.bar-stack {
  width: 100%;
  display: flex;
  align-items: end;
  justify-content: center;
  gap: 8px;
  height: 100%;
}

.bar {
  width: 16px;
  border-radius: 10px 10px 6px 6px;
  background: linear-gradient(180deg, var(--primary) 0%, var(--primary-strong) 100%);
  display: block;
  min-height: 20px;
}

.bar.purple {
  background: linear-gradient(180deg, var(--purple) 0%, #533ed4 100%);
}

.bar-label {
  font-size: 0.75rem;
  color: var(--muted);
  font-weight: 600;
}

.risk-list,
.projects-list,
.task-list,
.invoice-list,
.team-list {
  display: grid;
  gap: 12px;
}

.risk-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 12px 14px;
  border: 1px solid var(--line);
  border-radius: 14px;
  background: var(--panel-alt);
}

.risk-copy {
  display: flex;
  align-items: center;
  gap: 10px;
}

.risk-copy strong {
  display: block;
  margin-bottom: 2px;
  font-size: 0.9rem;
}

.risk-copy span {
  color: var(--muted);
  font-size: 0.76rem;
}

.dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  display: inline-block;
}

.dot.red { background: var(--danger); }
.dot.orange { background: var(--warning); }
.dot.blue { background: var(--primary); }

.chip {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 28px;
  height: 28px;
  border-radius: 999px;
  font-size: 0.82rem;
  font-weight: 800;
}

.chip.warning {
  background: var(--warning-soft);
  color: #b8741a;
}

.chip.danger {
  background: var(--danger-soft);
  color: var(--danger);
}

.project-item {
  padding: 14px 16px;
  border: 1px solid var(--line);
  border-radius: 14px;
  background: var(--panel-alt);
}

.project-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  margin-bottom: 10px;
}

.project-title {
  font-weight: 700;
}

.badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 6px 10px;
  border-radius: 999px;
  font-size: 0.72rem;
  font-weight: 800;
}

.badge.success {
  background: var(--success-soft);
  color: var(--success);
}

.badge.warning {
  background: var(--warning-soft);
  color: #c98b2d;
}

.project-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  color: var(--muted);
  font-size: 0.8rem;
  margin-bottom: 12px;
}

.progress-bar {
  height: 10px;
  border-radius: 999px;
  background: #eef4fb;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  border-radius: inherit;
  background: linear-gradient(90deg, var(--primary) 0%, #63d2ff 100%);
}

.task-item,
.invoice-item,
.team-member {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  padding: 12px 0;
  border-bottom: 1px solid var(--line);
}

.task-item:last-child,
.invoice-item:last-child,
.team-member:last-child {
  border-bottom: none;
}

.task-label {
  display: flex;
  align-items: center;
  gap: 10px;
}

.lower-grid {
  grid-template-columns: 1.4fr 1fr;
}

.bottom-grid {
  display: grid;
  grid-template-columns: 1.2fr 0.8fr 0.8fr;
  gap: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th,
td {
  text-align: left;
  padding: 12px 8px;
  border-bottom: 1px solid var(--line);
}

th {
  color: var(--muted);
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.06em;
}

.stock-pill {
  display: inline-flex;
  padding: 6px 10px;
  border-radius: 999px;
  font-size: 0.72rem;
  font-weight: 800;
}

.stock-pill.ok {
  background: var(--success-soft);
  color: var(--success);
}

.stock-pill.low {
  background: var(--warning-soft);
  color: #c98b2d;
}

.invoice-info strong {
  display: block;
  margin-bottom: 4px;
}

.invoice-info span,
.team-meta {
  color: var(--muted);
  font-size: 0.8rem;
}

.money {
  font-weight: 800;
}

.team-member {
  padding: 12px 0;
}

.avatar {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  display: grid;
  place-items: center;
  color: white;
  font-size: 0.8rem;
  font-weight: 700;
}

.avatar.blue { background: linear-gradient(135deg, #4db2ff 0%, #1e88e5 100%); }
.avatar.green { background: linear-gradient(135deg, #4ad6a1 0%, #17a673 100%); }
.avatar.orange { background: linear-gradient(135deg, #ffc36a 0%, #f0ad4e 100%); }
.avatar.purple { background: linear-gradient(135deg, #a088ff 0%, #7c5cff 100%); }

.team-name {
  display: flex;
  align-items: center;
  gap: 10px;
}

@media (max-width: 1200px) {
  .bottom-grid {
    grid-template-columns: 1fr 1fr;
  }
}

@media (max-width: 980px) {
  .app-shell {
    grid-template-columns: 1fr;
  }

  .sidebar {
    padding-bottom: 18px;
  }

  .stats-grid,
  .content-grid,
  .bottom-grid {
    grid-template-columns: 1fr 1fr;
  }

  .lower-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 640px) {
  .main-content {
    padding: 18px;
  }

  .topbar,
  .overview-head {
    flex-direction: column;
    align-items: flex-start;
  }

  .search-wrap {
    min-width: 100%;
  }

  .stats-grid,
  .content-grid,
  .bottom-grid {
    grid-template-columns: 1fr;
  }

  .chart-bars {
    gap: 10px;
  }
}
