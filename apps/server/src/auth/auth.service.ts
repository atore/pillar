import { Injectable } from '@nestjs/common';

@Injectable()
export class AuthService {
  private readonly users = [
    {
      email: 'admin@pillar.it',
      password: 'pillar123',
      role: 'master',
      permissions: ['read:all', 'write:all', 'approve:all', 'sync:all'],
    },
    {
      email: 'cantiere@pillar.it',
      password: 'pillar123',
      role: 'slave',
      permissions: ['read:assigned', 'write:assigned', 'upload:docs', 'sync:pending'],
    },
  ];

  login(email: string, password: string, role: 'master' | 'slave') {
    const user = this.users.find(
      (item) => item.email === email && item.password === password && item.role === role,
    );

    if (!user) {
      return {
        ok: false,
        message: 'Credenziali non valide per il ruolo selezionato',
      };
    }

    return {
      ok: true,
      token: `pillar-token-${role}-${Date.now()}`,
      user: {
        email: user.email,
        role: user.role,
        permissions: user.permissions,
      },
    };
  }
}
