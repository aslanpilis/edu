import { AgeGroup } from './auth';

export type SubjectCategory = 'math' | 'language' | 'stem' | 'sel' | 'creativity';

export type ActivityType = 
  | 'counting_drag_drop'
  | 'letter_phonics_match'
  | 'logic_pattern'
  | 'code_sequence'
  | 'science_quiz'
  | 'emotion_recognize';

export interface Curriculum {
  id: string;
  title: string;
  description: string;
  targetAgeGroup: AgeGroup;
  category: SubjectCategory;
  icon: string;
  color: string;
  order: number;
  isPublished: boolean;
}

export interface Module {
  id: string;
  curriculumId: string;
  title: string;
  description: string;
  icon: string;
  color: string;
  order: number;
}

export interface Activity {
  id: string;
  lessonId: string;
  title: string;
  instruction: string;
  voiceInstruction?: string;
  type: ActivityType;
  order: number;
  payload: Record<string, any>;
}

export interface Lesson {
  id: string;
  moduleId: string;
  curriculumId: string;
  title: string;
  description: string;
  estimatedDurationMinutes: number;
  xpReward: number;
  order: number;
  difficultyLevel: 'beginner' | 'intermediate' | 'advanced';
  activities: Activity[];
}
