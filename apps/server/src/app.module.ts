import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { SitesModule } from './sites/sites.module';
import { MaterialsModule } from './materials/materials.module';
import { SyncModule } from './sync/sync.module';
import { UsersModule } from './users/users.module';
import { DocumentsModule } from './documents/documents.module';
import { ChecklistsModule } from './checklists/checklists.module';

@Module({
  imports: [
    AuthModule,
    SitesModule,
    MaterialsModule,
    SyncModule,
    UsersModule,
    DocumentsModule,
    ChecklistsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
