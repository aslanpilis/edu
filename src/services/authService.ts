import { 
  signInWithEmailAndPassword, 
  createUserWithEmailAndPassword, 
  signOut as fbSignOut, 
  onAuthStateChanged 
} from 'firebase/auth';
import { firebaseStatus } from '../config/firebase';
import { ParentUser, ChildProfile, AgeGroup } from '../types/auth';
import { storageService } from './storageService';

export class AuthService {
  // E-posta & Şifre ile Giriş (Firebase Auth veya Demo Modu)
  public async signIn(email: string, pass: string): Promise<ParentUser> {
    if (storageService.isFirebaseLive() && firebaseStatus.auth) {
      const cred = await signInWithEmailAndPassword(firebaseStatus.auth, email, pass);
      let user = await storageService.getParentUser(cred.user.uid);
      if (!user) {
        user = {
          uid: cred.user.uid,
          email: cred.user.email || email,
          displayName: cred.user.displayName || email.split('@')[0],
          role: 'parent',
          subscriptionTier: 'free',
          createdAt: new Date().toISOString(),
          settings: { notifications: true, soundEnabled: true, language: 'tr' },
        };
        await storageService.saveParentUser(user);
      }
      return user;
    }

    // Demo / Yerel Mod Girişi
    const demoUser: ParentUser = {
      uid: 'parent_demo_user_123',
      email: email || 'veli@egitim.com',
      displayName: 'Ahmet Yılmaz (Ebeveyn)',
      role: 'parent',
      subscriptionTier: 'family',
      createdAt: new Date().toISOString(),
      isDemoUser: true,
      settings: { notifications: true, soundEnabled: true, language: 'tr' },
    };
    await storageService.saveParentUser(demoUser);
    return demoUser;
  }

  // Ebeveyn Kayıt
  public async signUp(email: string, pass: string, name: string): Promise<ParentUser> {
    if (storageService.isFirebaseLive() && firebaseStatus.auth) {
      const cred = await createUserWithEmailAndPassword(firebaseStatus.auth, email, pass);
      const user: ParentUser = {
        uid: cred.user.uid,
        email: cred.user.email || email,
        displayName: name || email.split('@')[0],
        role: 'parent',
        subscriptionTier: 'free',
        createdAt: new Date().toISOString(),
      settings: { notifications: true, soundEnabled: true, language: 'tr' },
      };
      await storageService.saveParentUser(user);
      return user;
    }

    const newUser: ParentUser = {
      uid: `parent_${Date.now()}`,
      email,
      displayName: name || 'Ebeveyn',
      role: 'parent',
      subscriptionTier: 'free',
      createdAt: new Date().toISOString(),
      settings: { notifications: true, soundEnabled: true, language: 'tr' },
    };
    await storageService.saveParentUser(newUser);
    return newUser;
  }

  public async signOut(): Promise<void> {
    if (storageService.isFirebaseLive() && firebaseStatus.auth) {
      try {
        await fbSignOut(firebaseStatus.auth);
      } catch (e) {}
    }
    localStorage.removeItem('edu_parent_user');
    localStorage.removeItem('edu_active_child_id');
  }

  public async getInitialUser(): Promise<ParentUser | null> {
    const local = localStorage.getItem('edu_parent_user');
    if (local) {
      try {
        return JSON.parse(local);
      } catch (e) {}
    }
    return null;
  }

  // Çocuk Profili Ekleme
  public async createChildProfile(
    parentId: string,
    nickname: string,
    age: number,
    avatarUrl: string
  ): Promise<ChildProfile> {
    let ageGroup: AgeGroup = '3-5';
    if (age >= 6 && age <= 8) ageGroup = '6-8';
    else if (age >= 9) ageGroup = '9-12';

    const child: ChildProfile = {
      id: `child_${Date.now()}`,
      parentId,
      nickname,
      avatarUrl,
      age,
      ageGroup,
      totalXp: 0,
      currentStreakDays: 1,
      lastActiveAt: new Date().toISOString(),
      createdAt: new Date().toISOString(),
      preferences: {
        soundEffects: true,
        voiceOver: age <= 6,
        theme: age <= 5 ? 'playful' : age <= 8 ? 'adventure' : 'cyber',
      },
      screenTimeLimits: {
        enabled: true,
        dailyMinutesLimit: age <= 5 ? 20 : age <= 8 ? 35 : 50,
        usedMinutesToday: 0,
        lastDateUsed: new Date().toISOString().split('T')[0],
      },
    };

    await storageService.saveChild(child);
    return child;
  }
}

export const authService = new AuthService();
