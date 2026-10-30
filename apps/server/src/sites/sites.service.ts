import { Injectable } from '@nestjs/common';

@Injectable()
export class SitesService {
  private readonly sites = [
    { id: 1, name: 'Residenza Vela', client: 'Vela Immobiliare', progress: 78, budget: 420000, due: '2026-10-17', manager: 'Giulia Rossi' },
    { id: 2, name: 'Centro commerciale Nord', client: 'Nord Retail', progress: 58, budget: 680000, due: '2026-10-24', manager: 'Luca Bianchi' },
    { id: 3, name: 'Ristrutturazione Piazza 4', client: 'Comune di Milano', progress: 92, budget: 310000, due: '2026-11-02', manager: 'Marco Verdi' },
    { id: 4, name: 'Palazzo San Marco', client: 'San Marco Group', progress: 66, budget: 540000, due: '2026-11-12', manager: 'Aurelia Neri' },
  ];

  findAll() {
    return this.sites;
  }

  create(site: any) {
    const created = { id: Date.now(), ...site };
    this.sites.unshift(created);
    return { ok: true, site: created };
  }
}
