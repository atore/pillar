import { Controller, Get, Post, Body } from '@nestjs/common';
import { SyncEvent, SyncService } from './sync.service';

@Controller('sync')
export class SyncController {
  constructor(private readonly syncService: SyncService) {}

  @Get('devices')
  getDevices() {
    return this.syncService.getDevices();
  }

  @Get('queue')
  getQueue() {
    return this.syncService.getQueue();
  }

  @Post('event')
  receiveEvent(@Body() event: SyncEvent) {
    return this.syncService.pushEvent(event);
  }
}
