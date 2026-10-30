const stats = [
  { label: 'Fatturato', value: '€ 184.5k', trend: '+12.8%', type: 'positive', icon: '💰', color: '#1d9bf0' },
  { label: 'Cantieri attivi', value: '24', trend: '+4 oggi', type: 'positive', icon: '🏗️', color: '#17a673' },
  { label: 'Fatture in ritardo', value: '7', trend: '-2', type: 'warning', icon: '📄', color: '#f7b267' },
  { label: 'Ore programmate', value: '1.240h', trend: '+9.4%', type: 'positive', icon: '🧑‍🔧', color: '#7b61ff' },
];

const projects = [
  { name: 'Residenza Vela', progress: 78, status: 'In corso', owner: 'G. Rossi', due: '17 set' },
  { name: 'Centro commerciale Nord', progress: 58, status: 'Lavori strutturali', owner: 'L. Bianchi', due: '24 set' },
  { name: 'Ristrutturazione Piazza 4', progress: 92, status: 'Fase finale', owner: 'M. Verdi', due: '02 ott' },
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

const statsGrid = document.getElementById('statsGrid');
const projectsList = document.getElementById('projectsList');
const urgentTasksList = document.getElementById('urgentTasks');
const stockTable = document.getElementById('stockTable');
const invoicesList = document.getElementById('invoicesList');

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
