/**
 * Format date to a readable string
 */
export function formatDate(date: Date | string | undefined): string {
  if (!date) return 'Not set';
  const d = typeof date === 'string' ? new Date(date) : date;
  return d.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
}

/**
 * Format time duration in minutes to readable string
 */
export function formatDuration(minutes: number): string {
  const hours = Math.floor(minutes / 60);
  const mins = minutes % 60;
  
  if (hours === 0) return `${mins}m`;
  if (mins === 0) return `${hours}h`;
  return `${hours}h ${mins}m`;
}

/**
 * Get a color class based on subject
 */
export function getSubjectColor(subject: string): string {
  const colors: Record<string, string> = {
    pharmacology: 'blue',
    pathology: 'purple',
    microbiology: 'green',
  };
  return colors[subject] || 'gray';
}

/**
 * Get importance badge color
 */
export function getImportanceColor(importance: string): string {
  const colors: Record<string, string> = {
    high: 'red',
    medium: 'yellow',
    low: 'gray',
  };
  return colors[importance] || 'gray';
}

/**
 * Calculate completion percentage for resources
 */
export function calculateResourceCompletion(
  completedCount: number,
  totalCount: number
): number {
  if (totalCount === 0) return 0;
  return Math.round((completedCount / totalCount) * 100);
}
