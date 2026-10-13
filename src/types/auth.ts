export type UserRole = 'parent' | 'educator' | 'admin';
export type SubscriptionTier = 'free' | 'premium' | 'family';
export type AgeGroup = '3-5' | '6-8' | '9-12';

export interface ParentUser {
  uid: string;
  email: string;
  displayName: string;
  role: UserRole;
  subscriptionTier: SubscriptionTier;
  createdAt: string;
  isDemoUser?: boolean;
  settings: {
    notifications: boolean;
    soundEnabled: boolean;
    language: string;
  };
}

export interface ChildProfile {
  id: string;
  parentId: string;
  nickname: string;
  avatarUrl: string;
  age: number;
  ageGroup: AgeGroup;
  totalXp: number;
  currentStreakDays: number;
  lastActiveAt: string;
  createdAt: string;
  preferences: {
    soundEffects: boolean;
    voiceOver: boolean;
    theme: 'playful' | 'adventure' | 'cyber';
  };
  screenTimeLimits: {
    enabled: boolean;
    dailyMinutesLimit: number;
    usedMinutesToday: number;
    lastDateUsed: string;
  };
}
