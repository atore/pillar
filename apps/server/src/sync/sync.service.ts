import { Injectable } from '@nestjs/common';

export interface SyncEvent {
  deviceId: string;
  role: 'master' | 'slave';
  action: 'create' | 'update' | 'delete' | 'status';
  entity: string;
  payload: Record<string, any>;
  timestamp: string;
  version: number;
}

@Injectable()
export class SyncService {
  private readonly queue: SyncEvent[] = [];
  private readonly devices = new Map<string, { role: 'master' | 'slave'; lastSeen: number }>();

  registerDevice(deviceId: string, role: 'master' | 'slave') {
    this.devices.set(deviceId, { role, lastSeen: Date.now() });
  }

  pushEvent(event: SyncEvent) {
    this.queue.push(event);
    return event;
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
