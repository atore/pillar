import { Injectable } from '@nestjs/common';

@Injectable()
export class MaterialsService {
  private readonly materials = [
    { id: 1, name: 'Cemento', qty: 120, unit: 'sacchi', status: 'OK' },
    { id: 2, name: 'Travertino', qty: 34, unit: 'pannelli', status: 'Basso' },
    { id: 3, name: 'Ferramenta', qty: 245, unit: 'pezzi', status: 'OK' },
    { id: 4, name: 'Vernice esterna', qty: 18, unit: 'bidoni', status: 'Basso' },
  ];

  findAll() {
    return this.materials;
  }

  create(item: any) {
    const created = { id: Date.now(), ...item };
    this.materials.unshift(created);
    return { ok: true, item: created };
  }
}
