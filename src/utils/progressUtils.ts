import type { StudyTopic, Subject, ProgressMetrics } from '../types';

/**
 * Calculate the overall progress percentage across all topics
 */
export function calculateTotalProgress(topics: StudyTopic[]): number {
  if (topics.length === 0) return 0;
  const totalProgress = topics.reduce((sum, topic) => sum + topic.progress, 0);
  return Math.round(totalProgress / topics.length);
}

/**
 * Calculate progress for a specific subject
 */
export function calculateSubjectProgress(topics: StudyTopic[], subject: Subject): number {
  const subjectTopics = topics.filter(t => t.subject === subject);
  if (subjectTopics.length === 0) return 0;
  const totalProgress = subjectTopics.reduce((sum, topic) => sum + topic.progress, 0);
  return Math.round(totalProgress / subjectTopics.length);
}

/**
 * Get topics that need attention (low progress or overdue for revision)
 */
export function getWeakTopics(topics: StudyTopic[], limit: number = 5): StudyTopic[] {
  return [...topics]
    .filter(topic => !topic.completed)
    .sort((a, b) => {
      // Prioritize by progress (lower first) and revision status
      const progressDiff = a.progress - b.progress;
      if (progressDiff !== 0) return progressDiff;
      
      const revisionDiff = (a.revisions / a.targetRevisions) - (b.revisions / b.targetRevisions);
      return revisionDiff;
    })
    .slice(0, limit);
}

/**
 * Calculate days until exam
 */
export function getDaysUntilExam(examDate?: Date): number | undefined {
  if (!examDate) return undefined;
  const now = new Date();
  const diff = examDate.getTime() - now.getTime();
  return Math.max(0, Math.ceil(diff / (1000 * 60 * 60 * 24)));
}

/**
 * Calculate comprehensive progress metrics
 */
export function calculateProgressMetrics(
  topics: StudyTopic[],
  examDate?: Date
): ProgressMetrics {
  const totalProgress = calculateTotalProgress(topics);
  const totalRevisions = topics.reduce((sum, topic) => sum + topic.revisions, 0);
  const weakTopics = getWeakTopics(topics);
  const daysUntilExam = getDaysUntilExam(examDate);

  const subjectProgress: Record<Subject, number> = {
    pharmacology: calculateSubjectProgress(topics, 'pharmacology'),
    pathology: calculateSubjectProgress(topics, 'pathology'),
    microbiology: calculateSubjectProgress(topics, 'microbiology'),
  };

  return {
    totalProgress,
    subjectProgress,
    totalRevisions,
    weakTopics,
    daysUntilExam,
  };
}
