export default function Dashboard() {
  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-6">
          Dashboard
        </h1>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white mb-2">
              Pharmacology
            </h2>
            <div className="text-4xl font-bold text-blue-600 dark:text-blue-400">0%</div>
            <p className="text-gray-600 dark:text-gray-400 mt-2">Progress</p>
          </div>
          
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white mb-2">
              Pathology
            </h2>
            <div className="text-4xl font-bold text-purple-600 dark:text-purple-400">0%</div>
            <p className="text-gray-600 dark:text-gray-400 mt-2">Progress</p>
          </div>
          
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white mb-2">
              Microbiology
            </h2>
            <div className="text-4xl font-bold text-green-600 dark:text-green-400">0%</div>
            <p className="text-gray-600 dark:text-gray-400 mt-2">Progress</p>
          </div>
        </div>
      </div>
    </div>
  );
}
