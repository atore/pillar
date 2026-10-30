import { Controller, Get, Post, Body } from '@nestjs/common';
import { SitesService } from './sites.service';

@Controller('sites')
export class SitesController {
  constructor(private readonly sitesService: SitesService) {}

  @Get()
  findAll() {
    return this.sitesService.findAll();
  }

  @Post()
  create(@Body() body: any) {
    return this.sitesService.create(body);
  }
}
