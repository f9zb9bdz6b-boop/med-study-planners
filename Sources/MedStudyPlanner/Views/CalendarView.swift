import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var studyPlans: [StudyPlan]
    @Query private var topics: [Topic]
    @Query(sort: \DailyTask.date) private var dailyTasks: [DailyTask]
    
    @State private var showWizard = false
    @State private var showReschedulingAlert = false
    
    var body: some View {
        NavigationStack {
            Group {
                if studyPlans.isEmpty {
                    wizardView
                } else {
                    sprintView
                }
            }
            .navigationTitle("Calendar")
            .onAppear {
                checkForMissedTasks()
            }
        }
    }
    
    // MARK: - Wizard View (Empty State)
    
    private var wizardView: some View {
        PlanWizardView()
    }
    
    // MARK: - Sprint View (Active State)
    
    private var sprintView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(dailyTasks, id: \.id) { task in
                    dailyTaskSection(task: task)
                }
            }
            .padding()
        }
        .alert("Rescheduling...", isPresented: $showReschedulingAlert) {
            Button("OK") { }
        } message: {
            Text("Moving missed tasks to the nearest Sunday or end of queue.")
        }
    }
    
    private func dailyTaskSection(task: DailyTask) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date Header
            HStack {
                Text(task.date, style: .date)
                    .font(.headline)
                if task.isMissed {
                    Text("MISSED")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .cornerRadius(4)
                }
                Spacer()
                Text(task.date.formatted(.dateTime.weekday(.wide)))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Topics
            let taskTopics = getTopicsForTask(task)
            if taskTopics.isEmpty {
                Text("No topics scheduled")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .padding(.vertical, 8)
            } else {
                ForEach(taskTopics, id: \.id) { topic in
                    topicCard(topic: topic, task: task)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func topicCard(topic: Topic, task: DailyTask) -> some View {
        HStack {
            Circle()
                .fill(topic.yieldLevel.color)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.name)
                    .font(.subheadline)
                    .strikethrough(topic.isCompleted)
                Text(topic.subject.rawValue.capitalized)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if topic.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
    
    private func getTopicsForTask(_ task: DailyTask) -> [Topic] {
        topics.filter { topic in
            task.assignedTopicIDs.contains(topic.id)
        }
    }
    
    private func checkForMissedTasks() {
        var hasMissed = false
        
        for task in dailyTasks {
            let taskTopics = getTopicsForTask(task)
            task.updateMissedStatus(topics: taskTopics)
            
            if task.isMissed {
                hasMissed = true
            }
        }
        
        if hasMissed {
            showReschedulingAlert = true
            rescheduleMissedTasks()
        }
        
        try? modelContext.save()
    }
    
    private func rescheduleMissedTasks() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Find all missed tasks
        let missedTasks = dailyTasks.filter { task in
            calendar.startOfDay(for: task.date) < today && task.isMissed
        }
        
        for missedTask in missedTasks {
            // Move incomplete topics to nearest Sunday or end
            let incompleteTopicIDs = missedTask.assignedTopicIDs.filter { topicID in
                !(topics.first(where: { $0.id == topicID })?.isCompleted ?? false)
            }
            
            if let nearestSunday = findNearestSunday(from: today) {
                if let sundayTask = dailyTasks.first(where: { 
                    calendar.isDate($0.date, inSameDayAs: nearestSunday) 
                }) {
                    sundayTask.assignedTopicIDs.append(contentsOf: incompleteTopicIDs)
                } else {
                    let newTask = DailyTask(date: nearestSunday, assignedTopicIDs: incompleteTopicIDs)
                    modelContext.insert(newTask)
                }
            }
            
            // Clear missed task
            missedTask.assignedTopicIDs.removeAll()
            missedTask.isMissed = false
        }
        
        try? modelContext.save()
    }
    
    private func findNearestSunday(from date: Date) -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        components.weekday = 1 // Sunday
        
        if let sunday = calendar.date(from: components), sunday >= date {
            return sunday
        } else {
            components.weekOfYear? += 1
            return calendar.date(from: components)
        }
    }
}

// MARK: - Plan Wizard View

struct PlanWizardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var topics: [Topic]
    
    @State private var examName = ""
    @State private var examDate = Date().addingTimeInterval(60 * 60 * 24 * 30) // 30 days from now
    @State private var selectedSystems: Set<String> = []
    
    private let allSystems = ["General", "ANS", "CVS", "CNS", "Hemodynamics", "Neoplasia", "Systemic", "Immunology", "CVS/Blood", "GI", "Resp"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Create Study Plan")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Set up your exam schedule and we'll organize your topics")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.bottom)
                
                // Exam Name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Exam Name")
                        .font(.headline)
                    TextField("e.g., USMLE Step 1", text: $examName)
                        .textFieldStyle(.roundedBorder)
                }
                
                // Exam Date
                VStack(alignment: .leading, spacing: 8) {
                    Text("Exam Date")
                        .font(.headline)
                    DatePicker("Select Date", selection: $examDate, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }
                
                // System Selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Systems")
                        .font(.headline)
                    
                    ForEach(allSystems, id: \.self) { system in
                        Toggle(system, isOn: Binding(
                            get: { selectedSystems.contains(system) },
                            set: { isSelected in
                                if isSelected {
                                    selectedSystems.insert(system)
                                } else {
                                    selectedSystems.remove(system)
                                }
                            }
                        ))
                    }
                }
                
                // Generate Button
                Button {
                    generatePlan()
                } label: {
                    Text("Generate Plan")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(examName.isEmpty || selectedSystems.isEmpty ? Color.gray : Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
                .disabled(examName.isEmpty || selectedSystems.isEmpty)
            }
            .padding()
        }
    }
    
    private func generatePlan() {
        // Create study plan
        let plan = StudyPlan(
            examName: examName,
            examDate: examDate,
            includedSystems: Array(selectedSystems)
        )
        modelContext.insert(plan)
        
        // Filter topics by selected systems
        let filteredTopics = topics.filter { topic in
            selectedSystems.contains(topic.systemCategory)
        }
        
        // Calculate timeline
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let examDay = calendar.startOfDay(for: examDate)
        let totalDays = calendar.dateComponents([.day], from: today, to: examDay).day ?? 30
        
        // Separate high yield and others
        let highYieldTopics = filteredTopics.filter { $0.yieldLevel == .high }
        let otherTopics = filteredTopics.filter { $0.yieldLevel != .high }
        
        // Calculate distribution
        let highYieldDays = Int(Double(totalDays) * 0.6)
        let topicsPerDay = max(1, highYieldTopics.count / max(1, highYieldDays))
        
        // Distribute topics
        var currentDate = today
        var topicIndex = 0
        var dailyTasksList: [DailyTask] = []
        
        // First 60% for high yield
        for _ in 0..<highYieldDays {
            // Skip Sundays
            while calendar.component(.weekday, from: currentDate) == 1 {
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            
            var taskTopicIDs: [UUID] = []
            for _ in 0..<topicsPerDay {
                if topicIndex < highYieldTopics.count {
                    taskTopicIDs.append(highYieldTopics[topicIndex].id)
                    topicIndex += 1
                }
            }
            
            if !taskTopicIDs.isEmpty {
                let task = DailyTask(date: currentDate, assignedTopicIDs: taskTopicIDs)
                dailyTasksList.append(task)
                modelContext.insert(task)
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        // Remaining days for other topics
        topicIndex = 0
        while topicIndex < otherTopics.count && currentDate < examDay {
            // Skip Sundays
            while calendar.component(.weekday, from: currentDate) == 1 {
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            
            var taskTopicIDs: [UUID] = []
            for _ in 0..<topicsPerDay {
                if topicIndex < otherTopics.count {
                    taskTopicIDs.append(otherTopics[topicIndex].id)
                    topicIndex += 1
                }
            }
            
            if !taskTopicIDs.isEmpty {
                let task = DailyTask(date: currentDate, assignedTopicIDs: taskTopicIDs)
                dailyTasksList.append(task)
                modelContext.insert(task)
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        plan.dailyTasks = dailyTasksList
        
        try? modelContext.save()
    }
}
