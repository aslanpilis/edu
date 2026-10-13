import React, { createContext, useContext, useState, useEffect } from 'react';
import { ParentUser, ChildProfile } from '../types/auth';
import { authService } from '../services/authService';
import { storageService } from '../services/storageService';
import { audioService } from '../services/audioService';

interface AuthContextType {
  user: ParentUser | null;
  activeChild: ChildProfile | null;
  childrenList: ChildProfile[];
  isLoading: boolean;
  isFirebaseConnected: boolean;
  signIn: (email: string, pass: string) => Promise<void>;
  signUp: (email: string, pass: string, name: string) => Promise<void>;
  signOut: () => Promise<void>;
  switchChild: (childId: string) => void;
  addChild: (nickname: string, age: number, avatarUrl: string) => Promise<ChildProfile>;
  updateChild: (child: ChildProfile) => Promise<void>;
  deleteChild: (childId: string) => Promise<void>;
  refreshChildren: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<ParentUser | null>(null);
  const [activeChild, setActiveChild] = useState<ChildProfile | null>(null);
  const [childrenList, setChildrenList] = useState<ChildProfile[]>([]);
  const [isLoading, setIsLoading] = useState<boolean>(true);

  const isFirebaseConnected = storageService.isFirebaseLive();

  // Initial load
  useEffect(() => {
    async function loadData() {
      try {
        let initialUser = await authService.getInitialUser();
        if (!initialUser) {
          // Auto-login with default demo user for frictionless immediate preview
          initialUser = await authService.signIn('veli@egitim.com', 'demo123');
        }
        setUser(initialUser);

        if (initialUser) {
          const list = await storageService.getChildren(initialUser.uid);
          setChildrenList(list);

          const savedChildId = localStorage.getItem('edu_active_child_id');
          const found = list.find((c) => c.id === savedChildId) || list[0] || null;
          setActiveChild(found);

          if (found) {
            audioService.setSoundEnabled(found.preferences.soundEffects);
            audioService.setVoiceOverEnabled(found.preferences.voiceOver);
          }
        }
      } catch (e) {
        console.error('Error loading initial auth state:', e);
      } finally {
        setIsLoading(false);
      }
    }
    loadData();
  }, []);

  const refreshChildren = async () => {
    if (!user) return;
    const list = await storageService.getChildren(user.uid);
    setChildrenList(list);
    if (activeChild) {
      const updated = list.find((c) => c.id === activeChild.id);
      if (updated) {
        setActiveChild(updated);
      }
    }
  };

  const handleSignIn = async (email: string, pass: string) => {
    setIsLoading(true);
    try {
      const u = await authService.signIn(email, pass);
      setUser(u);
      const list = await storageService.getChildren(u.uid);
      setChildrenList(list);
      const firstChild = list[0] || null;
      setActiveChild(firstChild);
      if (firstChild) {
        localStorage.setItem('edu_active_child_id', firstChild.id);
      }
    } finally {
      setIsLoading(false);
    }
  };

  const handleSignUp = async (email: string, pass: string, name: string) => {
    setIsLoading(true);
    try {
      const u = await authService.signUp(email, pass, name);
      setUser(u);
      const list = await storageService.getChildren(u.uid);
      setChildrenList(list);
      const firstChild = list[0] || null;
      setActiveChild(firstChild);
    } finally {
      setIsLoading(false);
    }
  };

  const handleSignOut = async () => {
    await authService.signOut();
    setUser(null);
    setActiveChild(null);
    setChildrenList([]);
  };

  const switchChild = (childId: string) => {
    const found = childrenList.find((c) => c.id === childId);
    if (found) {
      setActiveChild(found);
      localStorage.setItem('edu_active_child_id', found.id);
      audioService.setSoundEnabled(found.preferences.soundEffects);
      audioService.setVoiceOverEnabled(found.preferences.voiceOver);
      audioService.playPop();
    }
  };

  const addChild = async (nickname: string, age: number, avatarUrl: string): Promise<ChildProfile> => {
    if (!user) throw new Error('Oturum açmış kullanıcı bulunamadı');
    const newChild = await authService.createChildProfile(user.uid, nickname, age, avatarUrl);
    await refreshChildren();
    switchChild(newChild.id);
    return newChild;
  };

  const updateChild = async (child: ChildProfile) => {
    await storageService.saveChild(child);
    await refreshChildren();
  };

  const deleteChild = async (childId: string) => {
    if (!user) return;
    await storageService.deleteChild(user.uid, childId);
    await refreshChildren();
    if (activeChild?.id === childId) {
      const remaining = childrenList.filter((c) => c.id !== childId);
      setActiveChild(remaining[0] || null);
    }
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        activeChild,
        childrenList,
        isLoading,
        isFirebaseConnected,
        signIn: handleSignIn,
        signUp: handleSignUp,
        signOut: handleSignOut,
        switchChild,
        addChild,
        updateChild,
        deleteChild,
        refreshChildren,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
