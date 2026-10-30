import { Injectable } from '@nestjs/common';
import { DocumentItem } from '../common/types';

@Injectable()
export class DocumentsService {
  private readonly documents: DocumentItem[] = [
    {
      id: 1,
      name: 'foto-cantiere-01.jpg',
      type: 'photo',
      siteId: 1,
      uploadedBy: 'cantiere@pillar.it',
      uploadedAt: new Date().toISOString(),
      status: 'pending',
    },
    {
      id: 2,
      name: 'verbale-analisi.pdf',
      type: 'pdf',
      siteId: 2,
      uploadedBy: 'admin@pillar.it',
      uploadedAt: new Date().toISOString(),
      status: 'approved',
    },
  ];

  findAll() {
    return this.documents;
  }

  create(item: Partial<DocumentItem>) {
    const created: DocumentItem = {
      id: Date.now(),
      name: item.name ?? 'new-document',
      type: item.type ?? 'other',
      siteId: item.siteId ?? 1,
      uploadedBy: item.uploadedBy ?? 'system',
      uploadedAt: item.uploadedAt ?? new Date().toISOString(),
      status: item.status ?? 'pending',
    };

    this.documents.unshift(created);
    return { ok: true, document: created };
  }
}
