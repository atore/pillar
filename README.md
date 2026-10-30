const stats = [
  { label: 'Fatturato', value: '€ 184.5k', trend: '+12.8%', type: 'positive', icon: '💰', color: '#1e88e5' },
  { label: 'Cantieri attivi', value: '24', trend: '+4 oggi', type: 'positive', icon: '🏗️', color: '#17a673' },
  { label: 'Fatture in ritardo', value: '7', trend: '-2', type: 'warning', icon: '📄', color: '#f0ad4e' },
  { label: 'Ore programmate', value: '1.240h', trend: '+9.4%', type: 'positive', icon: '🧑‍🔧', color: '#7c5cff' },
];

const chartData = [
  { month: 'Gen', work: 28, budget: 18 },
  { month: 'Feb', work: 38, budget: 24 },
  { month: 'Mar', work: 33, budget: 20 },
  { month: 'Apr', work: 45, budget: 32 },
  { month: 'Mag', work: 58, budget: 40 },
  { month: 'Giu', work: 62, budget: 46 },
];

const risks = [
  { label: 'Nitrogeno e fognature', note: '2 interventi da pianificare', color: 'red' },
  { label: 'Sicurezza cantiere A12', note: 'Controllo scaduto in 3 giorni', color: 'orange' },
  { label: 'Materiali in ritardo', note: 'Fornitore estero su 2 forniture', color: 'blue' },
];

const projects = [
  { name: 'Residenza Vela', progress: 78, status: 'In corso', owner: 'G. Rossi', due: '17 set' },
  { name: 'Centro commerciale Nord', progress: 58, status: 'Lavori strutturali', owner: 'L. Bianchi', due: '24 set' },
  { name: 'Ristrutturazione Piazza 4', progress: 92, status: 'Fase finale', owner: 'M. Verdi', due: '02 ott' },
  { name: 'Palazzo San Marco', progress: 66, status: 'Pianificazione', owner: 'A. Neri', due: '12 nov' },
];

const urgentTasks = [
  { text: 'Confermare fornitura cemento', color: 'red' },
  { text: 'Controllo sicurezza cantiere A12', color: 'orange' },
  { text: 'Approvare preventivo ufficio tecnico', color: 'blue' },
];

const stock = [
  { item: 'Cemento', qty: '120 sacchi', state: 'OK', type: 'ok' },
  { item: 'Travertino', qty: '34 pannelli', state: 'Basso', type: 'low' },
  { item: 'Ferramenta', qty: '245 pezzi', state: 'OK', type: 'ok' },
  { item: 'Vernice esterna', qty: '18 bidoni', state: 'Basso', type: 'low' },
];

const invoices = [
  { id: 'FAT-2048', customer: 'Edilizia Roma Srl', amount: '€ 12.400', due: '08 ott' },
  { id: 'FAT-1957', customer: 'Vega Costruzioni', amount: '€ 8.900', due: '14 ott' },
  { id: 'FAT-1881', customer: 'Azienda M. De Luca', amount: '€ 5.700', due: '21 ott' },
];

const team = [
  { name: 'Giulia Rossi', role: 'Direzione lavori', shift: 'Turno A', color: 'blue' },
  { name: 'Marco Bianchi', role: 'Capo cantiere', shift: 'Turno B', color: 'green' },
  { name: 'Stefania Neri', role: 'Ufficio tecnico', shift: 'Turno A', color: 'orange' },
  { name: 'Luca Verdi', role: 'Logistica', shift: 'Turno C', color: 'purple' },
];

const statsGrid = document.getElementById('statsGrid');
const chartBars = document.getElementById('chartBars');
const riskList = document.getElementById('riskList');
const projectsList = document.getElementById('projectsList');
const urgentTasksList = document.getElementById('urgentTasks');
const stockTable = document.getElementById('stockTable');
const invoicesList = document.getElementById('invoicesList');
const teamList = document.getElementById('teamList');

statsGrid.innerHTML = stats
  .map(
    (stat) => `
      <article class="stat-card">
        <div class="stat-head">
          <h4>${stat.label}</h4>
          <div class="stat-icon" style="background:${stat.color}">${stat.icon}</div>
        </div>
        <p class="stat-value">${stat.value}</p>
        <span class="stat-trend ${stat.type}">${stat.trend}</span>
      </article>
    `
  )
  .join('');

chartBars.innerHTML = chartData
  .map(
    (item) => `
      <div class="bar-column">
        <div class="bar-stack">
          <span class="bar" style="height:${item.work}%"></span>
          <span class="bar purple" style="height:${item.budget}%"></span>
        </div>
        <span class="bar-label">${item.month}</span>
      </div>
    `
  )
  .join('');

riskList.innerHTML = risks
  .map(
    (risk) => `
      <div class="risk-item">
        <div class="risk-copy">
          <span class="dot ${risk.color}"></span>
          <div>
            <strong>${risk.label}</strong>
            <span>${risk.note}</span>
          </div>
        </div>
        <span class="badge warning">DA VEDERE</span>
      </div>
    `
  )
  .join('');

projectsList.innerHTML = projects
  .map(
    (project) => `
      <div class="project-item">
        <div class="project-top">
          <span class="project-title">${project.name}</span>
          <span class="badge ${project.progress >= 80 ? 'success' : 'warning'}">${project.status}</span>
        </div>
        <div class="project-meta">
          <span>Responsabile: ${project.owner}</span>
          <span>Scadenza ${project.due}</span>
        </div>
        <div class="progress-bar">
          <div class="progress-fill" style="width:${project.progress}%"></div>
        </div>
      </div>
    `
  )
  .join('');

urgentTasksList.innerHTML = urgentTasks
  .map(
    (task) => `
      <li class="task-item">
        <div class="task-label">
          <span class="dot ${task.color}"></span>
          <span>${task.text}</span>
        </div>
      </li>
    `
  )
  .join('');

stockTable.innerHTML = stock
  .map(
    (row) => `
      <tr>
        <td>${row.item}</td>
        <td>${row.qty}</td>
        <td><span class="stock-pill ${row.type}">${row.state}</span></td>
      </tr>
    `
  )
  .join('');

invoicesList.innerHTML = invoices
  .map(
    (invoice) => `
      <li class="invoice-item">
        <div class="invoice-info">
          <strong>${invoice.id}</strong>
          <span>${invoice.customer}</span>
        </div>
        <div>
          <div class="money">${invoice.amount}</div>
          <span>${invoice.due}</span>
        </div>
      </li>
    `
  )
  .join('');

teamList.innerHTML = team
  .map(
    (member) => `
      <div class="team-member">
        <div class="team-name">
          <div class="avatar ${member.color}">${member.name.split(' ').map((n) => n[0]).slice(0, 2).join('')}</div>
          <div>
            <strong>${member.name}</strong>
            <div class="team-meta">${member.role}</div>
          </div>
        </div>
        <span class="badge warning">${member.shift}</span>
      </div>
    `
  )
  .join('');
