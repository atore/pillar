import { Injectable } from '@nestjs/common';

export interface SyncEvent {
  deviceId: string;
  role: 'master' | 'slave';
  action: 'create' | 'update' | 'delete' | 'status';
  entity: string;
  payload: Record<string, any>;
  timestamp: string;
  version: number;
  status?: 'pending' | 'approved' | 'rejected';
}

@Injectable()
export class SyncService {
  private readonly queue: SyncEvent[] = [
    {
      deviceId: 'demo-device-01',
      role: 'slave',
      action: 'create',
      entity: 'site',
      payload: { name: 'Cantiere Demo', progress: 55 },
      timestamp: new Date().toISOString(),
      version: 1,
      status: 'pending',
    },
  ];

  private readonly devices = new Map<string, { role: 'master' | 'slave'; lastSeen: number }>();

  registerDevice(deviceId: string, role: 'master' | 'slave') {
    this.devices.set(deviceId, { role, lastSeen: Date.now() });
  }

  pushEvent(event: SyncEvent) {
    this.queue.push({ ...event, status: event.status ?? 'pending' });
    return this.queue[this.queue.length - 1];
  }

  getQueue() {
    return this.queue;
  }

  getDevices() {
    return Array.from(this.devices.entries()).map(([deviceId, value]) => ({
      deviceId,
      role: value.role,
      lastSeen: value.lastSeen,
    }));
  }
}
