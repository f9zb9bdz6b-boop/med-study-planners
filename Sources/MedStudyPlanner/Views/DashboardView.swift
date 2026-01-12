import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var topics: [Topic]
    @Query private var studyPlans: [StudyPlan]
    @Query private var dailyTasks: [DailyTask]
    
    @State private var showFocusTimer = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Top Grid (2x2)
                    topMetricsGrid
                    
                    // Readiness Dial
                    readinessDial
                    
                    // Today's Action Deck
                    todaysActionDeck
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .overlay(alignment: .bottomTrailing) {
                // FAB: Start Study
                Button {
                    showFocusTimer = true
                } label: {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                        .background(
                            Circle()
                                .fill(.white)
                                .frame(width: 62, height: 62)
                        )
                }
                .padding(30)
            }
            .sheet(isPresented: $showFocusTimer) {
                FocusTimerView()
            }
        }
    }
    
    private var topMetricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            // Cell 1: Days Left
            VStack {
                Text("Days Left")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(daysLeft)")
                    .font(.largeTitle)
                    .bold()
            }
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            
            // Cell 2: Pharmacology Progress
            progressRing(subject: .pharmacology)
            
            // Cell 3: Pathology Progress
            progressRing(subject: .pathology)
            
            // Cell 4: Microbiology Progress
            progressRing(subject: .microbiology)
        }
    }
    
    private func progressRing(subject: Subject) -> some View {
        let subjectTopics = topics.filter { $0.subject == subject }
        let completed = subjectTopics.filter { $0.isCompleted }.count
        let total = subjectTopics.count
        let progress = total > 0 ? Double(completed) / Double(total) : 0.0
        
        return VStack {
            Text(subject.rawValue.capitalized)
                .font(.caption)
                .foregroundStyle(.secondary)
            ZStack {
                Circle()
                    .stroke(subject.color.opacity(0.2), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(subject.color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text("\(Int(progress * 100))%")
                    .font(.headline)
            }
            .frame(width: 60, height: 60)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(subject.color.opacity(0.05))
        .cornerRadius(12)
    }
    
    private var readinessDial: some View {
        VStack {
            Text("Readiness Score")
                .font(.headline)
            
            let score = calculateReadinessScore()
            
            Gauge(value: score, in: 0...100) {
                Text("Score")
            } currentValueLabel: {
                Text("\(Int(score))")
                    .font(.largeTitle)
                    .bold()
            }
            .gaugeStyle(.accessoryCircular)
            .tint(gaugeGradient(for: score))
            .scaleEffect(2)
            .padding(40)
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func gaugeGradient(for score: Double) -> LinearGradient {
        if score < 40 {
            return LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
        } else if score < 70 {
            return LinearGradient(colors: [.orange, .yellow], startPoint: .leading, endPoint: .trailing)
        } else {
            return LinearGradient(colors: [.yellow, .green], startPoint: .leading, endPoint: .trailing)
        }
    }
    
    private var todaysActionDeck: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Action Deck")
                .font(.headline)
            
            let todaysTasks = getTodaysTasks()
            
            if todaysTasks.isEmpty {
                Text("No tasks for today! 🎉")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(todaysTasks, id: \.id) { topic in
                    topicActionRow(topic: topic)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func topicActionRow(topic: Topic) -> some View {
        HStack {
            Circle()
                .fill(topic.yieldLevel.color)
                .frame(width: 12, height: 12)
            
            Text(topic.name)
                .strikethrough(topic.isCompleted)
            
            Spacer()
            
            Text(topic.subject.rawValue.capitalized)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                markTopicAsDone(topic)
            } label: {
                Label("Done", systemImage: "checkmark")
            }
            .tint(.green)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                pushToTomorrow(topic)
            } label: {
                Label("Tomorrow", systemImage: "arrow.forward")
            }
            .tint(.orange)
        }
    }
    
    // MARK: - Computed Properties
    
    private var daysLeft: Int {
        guard let plan = studyPlans.first else { return 0 }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let examDay = calendar.startOfDay(for: plan.examDate)
        let components = calendar.dateComponents([.day], from: today, to: examDay)
        return max(components.day ?? 0, 0)
    }
    
    private func calculateReadinessScore() -> Double {
        let highYieldDone = topics.filter { $0.yieldLevel == .high && $0.isCompleted }.count * 2
        let medYieldDone = topics.filter { $0.yieldLevel == .medium && $0.isCompleted }.count * 1
        let totalHighYield = topics.filter { $0.yieldLevel == .high }.count * 2
        let totalMedYield = topics.filter { $0.yieldLevel == .medium }.count * 1
        let total = totalHighYield + totalMedYield
        
        guard total > 0 else { return 0 }
        
        return min(Double(highYieldDone + medYieldDone) / Double(total) * 100, 100)
    }
    
    private func getTodaysTasks() -> [Topic] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Find today's daily task
        let todaysTask = dailyTasks.first { task in
            calendar.isDate(task.date, inSameDayAs: today)
        }
        
        guard let task = todaysTask else { return [] }
        
        // Get topics for today's task
        return topics.filter { topic in
            task.assignedTopicIDs.contains(topic.id)
        }
    }
    
    // MARK: - Actions
    
    private func markTopicAsDone(_ topic: Topic) {
        topic.isCompleted = true
        topic.completionDate = Date()
        topic.lastRevisionDate = Date()
        try? modelContext.save()
    }
    
    private func pushToTomorrow(_ topic: Topic) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Remove from today's task
        if let todaysTask = dailyTasks.first(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            todaysTask.assignedTopicIDs.removeAll { $0 == topic.id }
        }
        
        // Add to tomorrow's task or create one
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        if let tomorrowTask = dailyTasks.first(where: { calendar.isDate($0.date, inSameDayAs: tomorrow) }) {
            if !tomorrowTask.assignedTopicIDs.contains(topic.id) {
                tomorrowTask.assignedTopicIDs.append(topic.id)
            }
        } else {
            let newTask = DailyTask(date: tomorrow, assignedTopicIDs: [topic.id])
            modelContext.insert(newTask)
        }
        
        try? modelContext.save()
    }
}
