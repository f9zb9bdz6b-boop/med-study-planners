import { Link, useLocation } from 'react-router-dom';

export default function Navigation() {
  const location = useLocation();
  
  const isActive = (path: string) => location.pathname === path;
  
  const linkClass = (path: string) =>
    `px-4 py-2 rounded-lg transition-colors ${
      isActive(path)
        ? 'bg-blue-600 text-white'
        : 'text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700'
    }`;

  return (
    <nav className="bg-white dark:bg-gray-800 shadow-lg">
      <div className="container mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center space-x-8">
            <Link to="/" className="text-xl font-bold text-blue-600 dark:text-blue-400">
              MedSprint
            </Link>
            
            <div className="flex space-x-4">
              <Link to="/" className={linkClass('/')}>
                Dashboard
              </Link>
              <Link to="/pharmacology" className={linkClass('/pharmacology')}>
                Pharmacology
              </Link>
              <Link to="/pathology" className={linkClass('/pathology')}>
                Pathology
              </Link>
              <Link to="/microbiology" className={linkClass('/microbiology')}>
                Microbiology
              </Link>
              <Link to="/settings" className={linkClass('/settings')}>
                Settings
              </Link>
            </div>
          </div>
        </div>
      </div>
    </nav>
  );
}
