import { Injectable } from '@nestjs/common';

@Injectable()
export class SitesService {
  private readonly sites = [
    { id: 1, name: 'Residenza Vela', client: 'Vela Immobiliare', progress: 78 },
    { id: 2, name: 'Centro commerciale Nord', client: 'Nord Retail', progress: 58 },
  ];

  findAll() {
    return this.sites;
  }

  create(site: any) {
    this.sites.push({ id: Date.now(), ...site });
    return { ok: true, site };
  }
}
