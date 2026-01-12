# Med Study Planner

A comprehensive SwiftUI + SwiftData medical study planning application designed for MBBS exam preparation. Features intelligent topic organization, revision tracking, and adaptive study scheduling.

## 🎯 Features

### Data Architecture (SwiftData Models)

#### Core Models
- **Subject**: Pharmacology (Cyan), Pathology (Purple), Microbiology (Orange)
- **Yield Priority**: High (2.0x weight), Medium (1.0x), Low (0.5x)
- **Topic**: Comprehensive model with:
  - Completion tracking and revision dates
  - Subject-specific fields (Robbins page refs, Gram stain info)
  - User-editable mnemonic vault
  - Mandatory checklist items (topics can't be marked done until all mandatory items are checked)
  - Integrated notes with LMR (Last Minute Revision) support

#### Study Planning
- **StudyPlan**: Exam scheduling with system selection
- **DailyTask**: Adaptive task distribution with missed task detection

### User Interface

#### 1. Dashboard
- **Days Left Counter**: Countdown to exam date
- **Progress Rings**: Subject-wise completion tracking
- **Readiness Dial**: Smart scoring (High Yield × 2 + Medium Yield × 1)
  - Color gradient: Red (0-40) → Yellow (40-70) → Green (70-100)
- **Today's Action Deck**: 
  - Swipe right to mark done
  - Swipe left to push to tomorrow
- **FAB**: Quick access to Focus Timer

#### 2. Subject Trees
- **Accordion Organization**: Topics grouped by system category
- **Pathology Filter**: Toggle between General and Systemic
- **Microbiology Sort**: Organized by clinical system
- **Interactive Rows**:
  - Checkbox for completion
  - Yield badge (color-coded)
  - Deep link to Topic Detail

#### 3. Topic Detail
- **Mnemonic Vault**: Personal memory aids
- **Resource Checklist**: Subject-specific resources
  - Pharmacology: Video, KDT, Classification Chart
  - Pathology: Video, Robbins, *Morphology (mandatory), *Pathogenesis (mandatory)
  - Microbiology: Lab Diagnosis, Virulence, Culture
- **Notes Integration**: Rich text editor with LMR mode
- **Atlas Button**: Image gallery (TODO)

#### 4. Notes Vault
- **Split Editor**: Separate Explanation and Exam Answer sections
- **LMR Toggle**: Last Minute Revision mode for quick review
- **Markdown Support**: Format your notes for better organization

#### 5. Calendar Engine
- **Wizard Mode** (Empty State):
  - Exam date picker
  - System selection (multi-select)
  - Smart algorithm:
    - High yield topics in first 60% of timeline
    - Sunday buffer (no tasks on Sundays)
    - Automatic topic distribution
- **Sprint View** (Active State):
  - Daily task visualization
  - Missed task detection and auto-rescheduling
  - Move tasks to nearest Sunday or end of queue

#### 6. Analytics
- **Topic Decay Heatmap**: 
  - Green: Revised <3 days ago
  - Yellow: 3-14 days
  - Gray: >14 days
- **Progress Comparison**: Subject-wise completion bars
- **Statistics Dashboard**:
  - Total topics and completion count
  - High yield progress
  - Average revision count

#### 7. Focus Timer
- **Pre-flight Check**: Must set study goal before starting
- **Distraction Pad**: Capture random thoughts without losing focus
- **Countdown Timer**: Standard Pomodoro-style timer (25:00)

#### 8. Settings
- **Visuals**:
  - Force dark mode toggle
  - Font size slider (dynamic type support)
- **Data Management**:
  - Export progress as JSON
  - Reset completion status

## 📚 Pre-loaded Syllabus

### Pharmacology (40+ topics)
- **General**: Pharmacokinetics, Bioavailability, Loading Dose
- **ANS**: Pilocarpine, OP Poisoning, Adrenaline, Prazosin
- **CVS**: Captopril, Digoxin, Nitrates, Amiodarone
- **CNS**: Benzodiazepines, Phenytoin, Morphine, Ketamine

### Pathology (30+ topics)
- **General**: Necrosis, Apoptosis, Inflammation, Calcification
- **Hemodynamics**: Shock, Thrombosis, MI
- **Neoplasia**: Benign vs Malignant, Metastasis
- **Systemic**: Endocarditis, Pneumonia, Cirrhosis

### Microbiology (25+ topics)
- **General**: Koch Postulates, PCR
- **Immunology**: Hypersensitivity, ELISA
- **CVS/Blood**: Typhoid, HIV, Malaria
- **GI**: Cholera, Hepatitis B
- **Respiratory**: TB, COVID-19

## 🏗️ Architecture

### Technology Stack
- **Framework**: SwiftUI (iOS 17+, macOS 14+)
- **Database**: SwiftData for persistence
- **Language**: Swift 6.2+

### Project Structure
```
Sources/MedStudyPlanner/
├── MedSprintApp.swift          # Main app entry point
├── Models/
│   ├── Models.swift            # SwiftData models and enums
│   └── DataSeeder.swift        # Initial syllabus data
└── Views/
    ├── DashboardView.swift     # Main dashboard
    ├── SubjectListView.swift   # Topic browser
    ├── TopicDetailView.swift   # Topic details and checklist
    ├── NotesView.swift         # Note editor
    ├── CalendarView.swift      # Study plan manager
    ├── AnalyticsView.swift     # Progress analytics
    ├── FocusTimerView.swift    # Study timer
    └── SettingsView.swift      # App settings
```

## 🚀 Getting Started

### Requirements
- iOS 17.0+ / macOS 14.0+
- Xcode 15.0+
- Swift 6.2+

### Installation
1. Clone the repository
2. Open the project in Xcode
3. Build and run on your device or simulator

### First Launch
1. App automatically seeds with 40+ medical topics
2. Navigate to Calendar tab
3. Create your first study plan:
   - Enter exam name
   - Select exam date
   - Choose systems to study
   - Generate plan

## 📱 Usage Tips

1. **Start with High Yield**: The app prioritizes high-yield topics in your study plan
2. **Daily Review**: Check the Dashboard daily for your action deck
3. **Use Mnemonics**: Build your personal mnemonic vault for better retention
4. **Track Decay**: Monitor the Analytics heatmap to identify topics needing revision
5. **Sunday Buffer**: Sundays are kept free for catch-up or review

## 🔧 Development

### Building from Source
```bash
# Using Swift Package Manager
swift build

# For iOS/macOS development, open in Xcode
open Package.swift
```

### Code Quality
- All force unwrapping has been replaced with safe optional handling
- SwiftData relationships use cascade delete rules
- Empty states handled gracefully throughout the app

## 🛣️ Roadmap

- [ ] Atlas image gallery implementation
- [ ] Enhanced LMR mode with markdown parsing
- [ ] Drag & drop for calendar task reordering
- [ ] Cloud sync via iCloud
- [ ] PYQ (Previous Year Questions) integration
- [ ] Spaced repetition algorithm
- [ ] PDF export for notes

## 📄 License

This project is part of a medical education initiative.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## 📞 Support

For questions or support, please open an issue on GitHub.

---

**Made with ❤️ for medical students**
