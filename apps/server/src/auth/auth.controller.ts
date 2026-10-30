import { Controller, Post, Body } from '@nestjs/common';
import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  login(@Body() body: { email: string; password: string; role: 'master' | 'slave' }) {
    return this.authService.login(body.email, body.password, body.role);
  }
}
