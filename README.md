# med-study-planner
Exam-based study planner for MBBS

## MedSprint App - Groundwork

This repository contains the foundational structure for the MedSprint medical study planning application.

### Features

- **Data Models**: TypeScript interfaces for StudyTopic, Resource, StudySession, CalendarEvent, UserSettings, and ProgressMetrics
- **Core Navigation**: React Router setup with Layout and Navigation components
- **UI Views**: Basic pages for Dashboard, Pharmacology, Pathology, Microbiology, and Settings
- **Utilities**: Helper functions for progress calculation, formatting, and local storage

### Tech Stack

- React 19 + TypeScript
- Vite (build tool)
- React Router v6 (routing)
- Tailwind CSS v4 (styling)
- ESLint (linting)

### Getting Started

```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Lint code
npm run lint
```

### Project Structure

```
src/
├── components/        # Reusable UI components
│   ├── Layout.tsx
│   └── Navigation.tsx
├── pages/            # Page components
│   ├── Dashboard.tsx
│   ├── Pharmacology.tsx
│   ├── Pathology.tsx
│   ├── Microbiology.tsx
│   └── Settings.tsx
├── types/            # TypeScript type definitions
│   └── index.ts
├── utils/            # Utility functions
│   ├── progressUtils.ts
│   ├── formatUtils.ts
│   ├── storageUtils.ts
│   └── index.ts
├── App.tsx           # Main app component with routing
└── main.tsx          # Application entry point
```
