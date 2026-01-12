/**
 * Save data to localStorage
 */
export function saveToLocalStorage<T>(key: string, data: T): void {
  try {
    const serialized = JSON.stringify(data);
    localStorage.setItem(key, serialized);
  } catch (error) {
    console.error(`Error saving to localStorage: ${error}`);
  }
}

/**
 * Load data from localStorage
 */
export function loadFromLocalStorage<T>(key: string, defaultValue: T): T {
  try {
    const serialized = localStorage.getItem(key);
    if (serialized === null) return defaultValue;
    const parsed = JSON.parse(serialized);
    // Return parsed data, relying on TypeScript's type system at compile time
    // Runtime validation would require a schema validation library
    return parsed as T;
  } catch (error) {
    console.error(`Error loading from localStorage: ${error}`);
    return defaultValue;
  }
}

/**
 * Remove data from localStorage
 */
export function removeFromLocalStorage(key: string): void {
  try {
    localStorage.removeItem(key);
  } catch (error) {
    console.error(`Error removing from localStorage: ${error}`);
  }
}

/**
 * Clear all app data from localStorage
 */
export function clearAllData(): void {
  try {
    const keys = ['topics', 'sessions', 'events', 'settings'];
    keys.forEach(key => localStorage.removeItem(key));
  } catch (error) {
    console.error(`Error clearing localStorage: ${error}`);
  }
}
