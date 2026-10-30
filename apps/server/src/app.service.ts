import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHealth() {
    return {
      ok: true,
      service: 'pillar-sync-server',
      mode: 'master-centralized',
      timestamp: new Date().toISOString(),
    };
  }
}
