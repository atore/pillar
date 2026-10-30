import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { SitesModule } from './sites/sites.module';
import { MaterialsModule } from './materials/materials.module';
import { SyncModule } from './sync/sync.module';

@Module({
  imports: [AuthModule, SitesModule, MaterialsModule, SyncModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
