export type UserRole = 'Flight Crew' | 'Ground Crew';

export interface User {
  id?: string;
  email: string;
  password?: string;
  firstName?: string;
  lastName?: string;
  username?: string;
  role?: UserRole;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface RegisterRequest {
  firstName: string;
  lastName: string;
  email: string;
  username: string;
  role: UserRole;
  password: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface AuthResponse {
  success: boolean;
  message: string;
  token?: string;
  user?: Omit<User, 'password'>;
}
