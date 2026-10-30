export type UserRole = 'master' | 'slave';

export interface AppUser {
  id: number;
  email: string;
  name: string;
  role: UserRole;
  siteId?: number | null;
  permissions: string[];
}

export interface DocumentItem {
  id: number;
  name: string;
  type: 'photo' | 'pdf' | 'doc' | 'other';
  siteId: number;
  uploadedBy: string;
  uploadedAt: string;
  status: 'pending' | 'approved' | 'rejected';
}

export interface ChecklistItem {
  id: number;
  siteId: number;
  title: string;
  description: string;
  completed: boolean;
  assignee: string;
  dueDate: string;
}
