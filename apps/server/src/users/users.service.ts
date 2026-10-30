import { Injectable } from '@nestjs/common';
import { AppUser, UserRole } from '../common/types';

@Injectable()
export class UsersService {
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
    {
      id: 3,
      email: 'warehouse@pillar.it',
      name: 'Magazzino',
      role: 'slave',
      siteId: 2,
      permissions: ['read:assigned', 'write:materials', 'sync:pending'],
    },
  ];

  findAll() {
    return this.users;
  }

  findOne(id: number) {
    return this.users.find((user) => user.id === id) ?? null;
  }

  findByEmail(email: string) {
    return this.users.find((user) => user.email.toLowerCase() === email.toLowerCase()) ?? null;
  }

  findRole(role: UserRole) {
    return this.users.filter((user) => user.role === role);
  }
}
