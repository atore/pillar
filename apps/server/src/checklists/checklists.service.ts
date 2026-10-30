import { Injectable } from '@nestjs/common';
import { ChecklistItem } from '../common/types';

@Injectable()
export class ChecklistsService {
  private readonly checklists: ChecklistItem[] = [
    {
      id: 1,
      siteId: 1,
      title: 'Verifica ponteggi',
      description: 'Controllo sicurezza ponteggi prima dell’avvio lavori',
      completed: false,
      assignee: 'Giulia Rossi',
      dueDate: '2026-11-03',
    },
    {
      id: 2,
      siteId: 2,
      title: 'Controllo materiali',
      description: 'Conferma disponibilità del materiale richiesto',
      completed: true,
      assignee: 'Marco Bianchi',
      dueDate: '2026-11-02',
    },
  ];

  findAll() {
    return this.checklists;
  }

  create(item: Partial<ChecklistItem>) {
    const created: ChecklistItem = {
      id: Date.now(),
      siteId: item.siteId ?? 1,
      title: item.title ?? 'Nuova checklist',
      description: item.description ?? 'Checklist generata',
      completed: item.completed ?? false,
      assignee: item.assignee ?? 'system',
      dueDate: item.dueDate ?? new Date().toISOString().slice(0, 10),
    };

    this.checklists.unshift(created);
    return { ok: true, checklist: created };
  }
}
