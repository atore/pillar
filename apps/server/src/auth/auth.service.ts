import { Injectable } from '@nestjs/common';

@Injectable()
export class AuthService {
  login(email: string, password: string, role: 'master' | 'slave') {
    const valid = email && password;
    if (!valid) {
      return { ok: false, message: 'Credenziali mancanti' };
    }

    return {
      ok: true,
      token: `mock-token-${role}-${email}`,
      user: {
        email,
        role,
        permissions: role === 'master'
          ? ['read:all', 'write:all', 'approve:all']
          : ['write:assigned', 'read:assigned', 'upload:docs'],
      },
    };
  }
}
