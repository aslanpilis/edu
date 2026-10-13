import React, { createContext, useContext, useState, useEffect } from 'react';
import { Lesson, Activity } from '../types/curriculum';
import { ChildProfile } from '../types/auth';
import { Achievement, ChildProgress } from '../types/progress';
import { progressService } from '../services/progressService';
import { audioService } from '../services/audioService';
import { useAuth } from './AuthContext';

interface LearningContextType {
  activeLesson: Lesson | null;
  activeActivity: Activity | null;
  activeActivityIndex: number;
  totalActivitiesCount: number;
  isSessionActive: boolean;
  isCompletedModalOpen: boolean;
  completionData: {
    progress: ChildProgress | null;
    xpEarned: number;
    starsEarned: number;
    timeSpentSeconds: number;
    scorePercentage: number;
  } | null;
  unlockedBadgeQueue: Achievement[];
  startLesson: (lesson: Lesson) => void;
  submitActivityAnswer: (isCorrect: boolean) => void;
  nextActivity: () => void;
  exitLesson: () => void;
  dismissBadgeNotification: () => void;
}

const LearningContext = createContext<LearningContextType | undefined>(undefined);

export const LearningProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { activeChild, updateChild } = useAuth();

  const [activeLesson, setActiveLesson] = useState<Lesson | null>(null);
  const [activeActivityIndex, setActiveActivityIndex] = useState<number>(0);
  const [sessionStartTime, setSessionStartTime] = useState<number>(0);
  const [correctAnswersCount, setCorrectAnswersCount] = useState<number>(0);
  const [isCompletedModalOpen, setIsCompletedModalOpen] = useState<boolean>(false);
  const [completionData, setCompletionData] = useState<any | null>(null);
  const [unlockedBadgeQueue, setUnlockedBadgeQueue] = useState<Achievement[]>([]);

  const activeActivity = activeLesson?.activities[activeActivityIndex] || null;
  const totalActivitiesCount = activeLesson?.activities.length || 0;

  // Sesli yönergeyi aktivite değiştiğinde otomatik oku (3-6 yaş için)
  useEffect(() => {
    if (activeActivity && activeChild?.preferences.voiceOver) {
      const textToSpeak = activeActivity.voiceInstruction || activeActivity.instruction;
      if (textToSpeak) {
        audioService.speak(textToSpeak);
      }
    }
  }, [activeActivity, activeChild]);

  const startLesson = (lesson: Lesson) => {
    setActiveLesson(lesson);
    setActiveActivityIndex(0);
    setCorrectAnswersCount(0);
    setSessionStartTime(Date.now());
    setIsCompletedModalOpen(false);
    setCompletionData(null);
    audioService.playPop();
  };

  const submitActivityAnswer = (isCorrect: boolean) => {
    if (isCorrect) {
      setCorrectAnswersCount((prev) => prev + 1);
      audioService.playSuccess();
    } else {
      audioService.playTryAgain();
    }
  };

  const nextActivity = async () => {
    if (!activeLesson || !activeChild) return;

    if (activeActivityIndex + 1 < totalActivitiesCount) {
      setActiveActivityIndex((prev) => prev + 1);
    } else {
      // Ders bitti, kaydet ve kutlama modalını aç
      const timeSpentSeconds = Math.max(15, Math.round((Date.now() - sessionStartTime) / 1000));
      const scorePercentage = Math.round((correctAnswersCount / totalActivitiesCount) * 100) || 100;

      const result = await progressService.recordLessonCompletion(
        activeChild,
        activeLesson,
        scorePercentage,
        timeSpentSeconds
      );

      await updateChild(result.updatedChild);

      if (result.newAchievements.length > 0) {
        setUnlockedBadgeQueue((prev) => [...prev, ...result.newAchievements]);
      }

      setCompletionData({
        progress: result.progress,
        xpEarned: result.xpEarned,
        starsEarned: result.starsEarned,
        timeSpentSeconds,
        scorePercentage,
      });

      setIsCompletedModalOpen(true);
    }
  };

  const exitLesson = () => {
    audioService.stopSpeaking();
    setActiveLesson(null);
    setActiveActivityIndex(0);
    setIsCompletedModalOpen(false);
    setCompletionData(null);
  };

  const dismissBadgeNotification = () => {
    setUnlockedBadgeQueue((prev) => prev.slice(1));
  };

  return (
    <LearningContext.Provider
      value={{
        activeLesson,
        activeActivity,
        activeActivityIndex,
        totalActivitiesCount,
        isSessionActive: !!activeLesson,
        isCompletedModalOpen,
        completionData,
        unlockedBadgeQueue,
        startLesson,
        submitActivityAnswer,
        nextActivity,
        exitLesson,
        dismissBadgeNotification,
      }}
    >
      {children}
    </LearningContext.Provider>
  );
};

export const useLearning = () => {
  const context = useContext(LearningContext);
  if (!context) {
    throw new Error('useLearning must be used within a LearningProvider');
  }
  return context;
};
