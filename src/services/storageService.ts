import { 
  collection, 
  doc, 
  setDoc, 
  getDoc, 
  getDocs, 
  query, 
  where, 
  orderBy, 
  updateDoc, 
  deleteDoc 
} from 'firebase/firestore';
import { firebaseStatus } from '../config/firebase';
import { ParentUser, ChildProfile } from '../types/auth';
import { ChildProgress, Achievement, DailyLog } from '../types/progress';
import { Curriculum, Module, Lesson } from '../types/curriculum';
import { SEED_CURRICULUMS, SEED_MODULES, SEED_LESSONS } from '../data/seedCurriculum';

// Local storage backup keys for simulated/offline mode
const LS_KEYS = {
  USER: 'edu_parent_user',
  CHILDREN: 'edu_children_profiles',
  ACTIVE_CHILD_ID: 'edu_active_child_id',
  PROGRESS: 'edu_progress_records',
  ACHIEVEMENTS: 'edu_achievements',
  DAILY_LOGS: 'edu_daily_logs',
};

export class StorageService {
  public isFirebaseLive(): boolean {
    return firebaseStatus.isConfigured && !!firebaseStatus.db;
  }

  // --- Parent User Storage ---
  public async saveParentUser(user: ParentUser): Promise<void> {
    localStorage.setItem(LS_KEYS.USER, JSON.stringify(user));

    if (this.isFirebaseLive() && firebaseStatus.db) {
      try {
        const userRef = doc(firebaseStatus.db, 'users', user.uid);
        await setDoc(userRef, user, { merge: true });
      } catch (err) {
        console.error('Firebase saveParentUser error:', err);
      }
    }
  }

  public async getParentUser(uid: string): Promise<ParentUser | null> {
    if (this.isFirebaseLive() && firebaseStatus.db) {
      try {
        const userRef = doc(firebaseStatus.db, 'users', uid);
        const snap = await getDoc(userRef);
        if (snap.exists()) {
          return snap.data() as ParentUser;
        }
      } catch (err) {
        console.error('Firebase getParentUser error:', err);
      }
    }

    const local = localStorage.getItem(LS_KEYS.USER);
    if (local) {
      try {
        return JSON.parse(local) as ParentUser;
      } catch (e) {}
    }
    return null;
  }

  // --- Children Profiles ---
  public async getChildren(parentId: string): Promise<ChildProfile[]> {
    if (this.isFirebaseLive() && firebaseStatus.db) {
      try {
        const colRef = collection(firebaseStatus.db, `users/${parentId}/children`);
        const snap = await getDocs(colRef);
        const children: ChildProfile[] = [];
        snap.forEach((docSnap) => {
          children.push(docSnap.data() as ChildProfile);
        });
        if (children.length > 0) {
          localStorage.setItem(LS_KEYS.CHILDREN, JSON.stringify(children));
          return children;
        }
      } catch (err) {
        console.error('Firebase getChildren error:', err);
      }
    }

    const local = localStorage.getItem(LS_KEYS.CHILDREN);
    if (local) {
      try {
        return JSON.parse(local) as ChildProfile[];
      } catch (e) {}
    }

    // Default pre-seeded child profiles for initial demo experience
    const initialChildren: ChildProfile[] = [
      {
        id: 'child_demo_1',
        parentId,
        nickname: 'Ece (4 Yaş)',
        avatarUrl: '🦊',
        age: 4,
        ageGroup: '3-5',
        totalXp: 120,
        currentStreakDays: 2,
        lastActiveAt: new Date().toISOString(),
        createdAt: new Date().toISOString(),
        preferences: { soundEffects: true, voiceOver: true, theme: 'playful' },
        screenTimeLimits: { enabled: true, dailyMinutesLimit: 25, usedMinutesToday: 8, lastDateUsed: new Date().toISOString().split('T')[0] },
      },
      {
        id: 'child_demo_2',
        parentId,
        nickname: 'Can (7 Yaş)',
        avatarUrl: '🚀',
        age: 7,
        ageGroup: '6-8',
        totalXp: 340,
        currentStreakDays: 4,
        lastActiveAt: new Date().toISOString(),
        createdAt: new Date().toISOString(),
        preferences: { soundEffects: true, voiceOver: true, theme: 'adventure' },
        screenTimeLimits: { enabled: true, dailyMinutesLimit: 35, usedMinutesToday: 15, lastDateUsed: new Date().toISOString().split('T')[0] },
      },
      {
        id: 'child_demo_3',
        parentId,
        nickname: 'Deniz (10 Yaş)',
        avatarUrl: '🤖',
        age: 10,
        ageGroup: '9-12',
        totalXp: 820,
        currentStreakDays: 6,
        lastActiveAt: new Date().toISOString(),
        createdAt: new Date().toISOString(),
        preferences: { soundEffects: true, voiceOver: false, theme: 'cyber' },
        screenTimeLimits: { enabled: false, dailyMinutesLimit: 45, usedMinutesToday: 20, lastDateUsed: new Date().toISOString().split('T')[0] },
      },
    ];

    localStorage.setItem(LS_KEYS.CHILDREN, JSON.stringify(initialChildren));
    return initialChildren;
  }

  public async saveChild(child: ChildProfile): Promise<void> {
    const children = await this.getChildren(child.parentId);
    const idx = children.findIndex((c) => c.id === child.id);
    if (idx >= 0) {
      children[idx] = child;
    } else {
      children.push(child);
    }
    localStorage.setItem(LS_KEYS.CHILDREN, JSON.stringify(children));

    if (this.isFirebaseLive() && firebaseStatus.db) {
      try {
        const docRef = doc(firebaseStatus.db, `users/${child.parentId}/children`, child.id);
        await setDoc(docRef, child, { merge: true });
      } catch (err) {
        console.error('Firebase saveChild error:', err);
      }
    }
  }

  public async deleteChild(parentId: string, childId: string): Promise<void> {
    const children = (await this.getChildren(parentId)).filter((c) => c.id !== childId);
    localStorage.setItem(LS_KEYS.CHILDREN, JSON.stringify(children));

    if (this.isFirebaseLive() && firebaseStatus.db) {
      try {
        const docRef = doc(firebaseStatus.db, `users/${parentId}/children`, childId);
        await deleteDoc(docRef);
      } catch (err) {
        console.error('Firebase deleteChild error:', err);
      }
    }
  }

  // --- Progress Tracking ---
  public async getChildProgress(childId: string): Promise<ChildProgress[]> {
    if (this.isFirebaseLive() && firebaseStatus.db) {
      try {
        const q = query(
          collection(firebaseStatus.db, 'progress'),
          where('childId', '==', childId)
        );
        const snap = await getDocs(q);
        const progressList: ChildProgress[] = [];
        snap.forEach((d) => progressList.push(d.data() as ChildProgress));
        return progressList;
      } catch (err) {
        console.error('Firebase getChildProgress error:', err);
      }
    }

    const local = localStorage.getItem(LS_KEYS.PROGRESS);
    if (local) {
      try {
        const all: ChildProgress[] = JSON.parse(local);
        return all.filter((p) => p.childId === childId);
      } catch (e) {}
    }
    return [];
  }

  public async saveProgress(progress: ChildProgress): Promise<void> {
    const local = localStorage.getItem(LS_KEYS.PROGRESS);
    let all: ChildProgress[] = local ? JSON.parse(local) : [];
    const idx = all.findIndex((p) => p.id === progress.id);
    if (idx >= 0) {
      all[idx] = progress;
    } else {
      all.push(progress);
    }
    localStorage.setItem(LS_KEYS.PROGRESS, JSON.stringify(all));

    if (this.isFirebaseLive() && firebaseStatus.db) {
      try {
        const docRef = doc(firebaseStatus.db, 'progress', progress.id);
        await setDoc(docRef, progress, { merge: true });
      } catch (err) {
        console.error('Firebase saveProgress error:', err);
      }
    }
  }

  // --- Achievements & Badges ---
  public async getAchievements(childId: string): Promise<Achievement[]> {
    if (this.isFirebaseLive() && firebaseStatus.db) {
      try {
        const q = query(
          collection(firebaseStatus.db, 'achievements'),
          where('childId', '==', childId)
        );
        const snap = await getDocs(q);
        const items: Achievement[] = [];
        snap.forEach((d) => items.push(d.data() as Achievement));
        return items;
      } catch (err) {
        console.error('Firebase getAchievements error:', err);
      }
    }

    const local = localStorage.getItem(LS_KEYS.ACHIEVEMENTS);
    if (local) {
      try {
        const all: Achievement[] = JSON.parse(local);
        return all.filter((a) => a.childId === childId);
      } catch (e) {}
    }
    return [];
  }

  public async saveAchievement(achievement: Achievement): Promise<void> {
    const local = localStorage.getItem(LS_KEYS.ACHIEVEMENTS);
    let all: Achievement[] = local ? JSON.parse(local) : [];
    if (!all.some((a) => a.id === achievement.id)) {
      all.push(achievement);
      localStorage.setItem(LS_KEYS.ACHIEVEMENTS, JSON.stringify(all));
    }

    if (this.isFirebaseLive() && firebaseStatus.db) {
      try {
        const docRef = doc(firebaseStatus.db, 'achievements', achievement.id);
        await setDoc(docRef, achievement, { merge: true });
      } catch (err) {
        console.error('Firebase saveAchievement error:', err);
      }
    }
  }

  // --- Daily Logs ---
  public async getDailyLogs(childId: string): Promise<DailyLog[]> {
    if (this.isFirebaseLive() && firebaseStatus.db) {
      try {
        const q = query(
          collection(firebaseStatus.db, 'daily_logs'),
          where('childId', '==', childId)
        );
        const snap = await getDocs(q);
        const logs: DailyLog[] = [];
        snap.forEach((d) => logs.push(d.data() as DailyLog));
        return logs;
      } catch (err) {
        console.error('Firebase getDailyLogs error:', err);
      }
    }

    const local = localStorage.getItem(LS_KEYS.DAILY_LOGS);
    if (local) {
      try {
        const all: DailyLog[] = JSON.parse(local);
        return all.filter((l) => l.childId === childId);
      } catch (e) {}
    }
    return [];
  }

  public async recordDailyLog(
    childId: string,
    minutes: number,
    xp: number,
    skill: string
  ): Promise<void> {
    const today = new Date().toISOString().split('T')[0];
    const logId = `${childId}_${today}`;
    const logs = await this.getDailyLogs(childId);
    let todayLog = logs.find((l) => l.id === logId);

    if (!todayLog) {
      todayLog = {
        id: logId,
        childId,
        date: today,
        minutesSpent: minutes,
        lessonsCompleted: 1,
        xpEarned: xp,
        skillsExercised: [skill],
      };
    } else {
      todayLog.minutesSpent += minutes;
      todayLog.lessonsCompleted += 1;
      todayLog.xpEarned += xp;
      if (!todayLog.skillsExercised.includes(skill)) {
        todayLog.skillsExercised.push(skill);
      }
    }

    const local = localStorage.getItem(LS_KEYS.DAILY_LOGS);
    let all: DailyLog[] = local ? JSON.parse(local) : [];
    const idx = all.findIndex((l) => l.id === logId);
    if (idx >= 0) {
      all[idx] = todayLog;
    } else {
      all.push(todayLog);
    }
    localStorage.setItem(LS_KEYS.DAILY_LOGS, JSON.stringify(all));

    if (this.isFirebaseLive() && firebaseStatus.db) {
      try {
        const docRef = doc(firebaseStatus.db, 'daily_logs', logId);
        await setDoc(docRef, todayLog, { merge: true });
      } catch (err) {
        console.error('Firebase recordDailyLog error:', err);
      }
    }
  }

  // --- Curriculum Queries ---
  public getCurriculums(ageGroup?: string): Curriculum[] {
    if (!ageGroup) return SEED_CURRICULUMS;
    return SEED_CURRICULUMS.filter((c) => c.targetAgeGroup === ageGroup);
  }

  public getModules(curriculumId: string): Module[] {
    return SEED_MODULES.filter((m) => m.curriculumId === curriculumId);
  }

  public getLessons(moduleId: string): Lesson[] {
    return SEED_LESSONS.filter((l) => l.moduleId === moduleId);
  }

  public getLessonById(lessonId: string): Lesson | undefined {
    return SEED_LESSONS.find((l) => l.id === lessonId);
  }
}

export const storageService = new StorageService();
