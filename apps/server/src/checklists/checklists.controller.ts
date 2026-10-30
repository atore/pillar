import { Controller, Get, Post, Body } from '@nestjs/common';
import { ChecklistsService } from './checklists.service';

@Controller('checklists')
export class ChecklistsController {
  constructor(private readonly checklistsService: ChecklistsService) {}

  @Get()
  findAll() {
    return this.checklistsService.findAll();
  }

  @Post()
  create(@Body() body: any) {
    return this.checklistsService.create(body);
  }
}
