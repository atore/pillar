import { Injectable } from '@nestjs/common';
import { AppUser, UserRole } from '../common/types';

@Injectable()
export class AuthService {
  private readonly users: AppUser[] = [
    {
      id: 1,
      email: 'admin@pillar.it',
      name: 'Admin Centrale',
      role: 'master',
      siteId: null,
      permissions: ['read:all', 'write:all', 'approve:all', 'sync:all'],
    },
    {
      id: 2,
      email: 'cantiere@pillar.it',
      name: 'Operatore Cantiere',
      role: 'slave',
      siteId: 1,
      permissions: ['read:assigned', 'write:assigned', 'upload:docs', 'sync:pending'],
    },
  ];

  private createToken(role: UserRole, email: string) {
    return `pillar-token-${role}-${Buffer.from(email).toString('base64')}`;
  }

  login(email: string, password: string, role: UserRole) {
    const user = this.users.find(
      (item) => item.email.toLowerCase() === email.toLowerCase() && item.role === role,
    );

    if (!user || user.email !== email || password !== 'pillar123') {
      return {
        ok: false,
        message: 'Credenziali non valide per il ruolo selezionato',
      };
    }

    return {
      ok: true,
      token: this.createToken(role, user.email),
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        permissions: user.permissions,
      },
    };
  }
}
