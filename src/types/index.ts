export type Subject = 'pharmacology' | 'pathology' | 'microbiology';

export type Importance = 'high' | 'medium' | 'low';

export interface Resource {
  id: string;
  name: string;
  type: 'textbook' | 'video' | 'notes' | 'practice';
  pages?: string;
  url?: string;
  completed: boolean;
}

export interface StudyTopic {
  id: string;
  name: string;
  subject: Subject;
  importance: Importance;
  completed: boolean;
  progress: number;
  revisions: number;
  targetRevisions: number;
  resources: Resource[];
  lastStudied?: Date;
  timeSpent: number;
  notes?: string;
}

export interface StudySession {
  id: string;
  topicId: string;
  date: Date;
  duration: number;
  completed: boolean;
}

export interface CalendarEvent {
  id: string;
  topicId?: string;
  title: string;
  date: Date;
  type: 'study' | 'revision' | 'exam' | 'break';
}

export interface UserSettings {
  examDate?: Date;
  dailyStudyGoal: number;
  pomodoroWork: number;
  pomodoroShortBreak: number;
  pomodoroLongBreak: number;
  darkMode: boolean;
}

export interface ProgressMetrics {
  totalProgress: number;
  subjectProgress: Record<Subject, number>;
  totalRevisions: number;
  weakTopics: StudyTopic[];
  daysUntilExam?: number;
}
