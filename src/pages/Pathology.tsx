export default function Pathology() {
  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold text-purple-600 dark:text-purple-400 mb-6">
          Pathology
        </h1>
        <p className="text-gray-600 dark:text-gray-400 mb-8">
          Study topics for Pathology
        </p>
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
          <p className="text-gray-700 dark:text-gray-300">
            No topics available yet. Add topics to get started.
          </p>
        </div>
      </div>
    </div>
  );
}
