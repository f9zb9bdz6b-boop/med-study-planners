import SwiftUI
import SwiftData

struct AnalyticsView: View {
    @Query private var topics: [Topic]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Topic Decay Heatmap
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Topic Decay Heatmap")
                            .font(.headline)
                        
                        decayHeatmap
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Neglect Radar
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Subject Progress Comparison")
                            .font(.headline)
                        
                        neglectRadar
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Statistics
                    statisticsSection
                }
                .padding()
            }
            .navigationTitle("Analytics")
        }
    }
    
    private var decayHeatmap: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
        
        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(topics.prefix(49), id: \.id) { topic in
                Rectangle()
                    .fill(decayColor(for: topic))
                    .frame(height: 40)
                    .cornerRadius(4)
                    .overlay(
                        Text(String(topic.name.prefix(2)))
                            .font(.caption2)
                            .foregroundStyle(.white)
                    )
            }
        }
    }
    
    private func decayColor(for topic: Topic) -> Color {
        guard let lastRevision = topic.lastRevisionDate else {
            return .gray
        }
        
        let daysSinceRevision = Calendar.current.dateComponents([.day], from: lastRevision, to: Date()).day ?? 0
        
        if daysSinceRevision < 3 {
            return .green
        } else if daysSinceRevision < 14 {
            return .yellow
        } else {
            return .gray
        }
    }
    
    private var neglectRadar: some View {
        VStack(spacing: 16) {
            ForEach(Subject.allCases, id: \.self) { subject in
                let subjectTopics = topics.filter { $0.subject == subject }
                let completed = subjectTopics.filter { $0.isCompleted }.count
                let total = subjectTopics.count
                let progress = total > 0 ? Double(completed) / Double(total) : 0.0
                
                HStack {
                    Text(subject.rawValue.capitalized)
                        .font(.subheadline)
                        .frame(width: 120, alignment: .leading)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(subject.color.opacity(0.2))
                                .frame(height: 30)
                            
                            Rectangle()
                                .fill(subject.color)
                                .frame(width: geometry.size.width * progress, height: 30)
                        }
                    }
                    .frame(height: 30)
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .frame(width: 50, alignment: .trailing)
                }
            }
        }
    }
    
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(.headline)
            
            HStack {
                statCard(title: "Total Topics", value: "\(topics.count)", color: .blue)
                statCard(title: "Completed", value: "\(completedTopics)", color: .green)
            }
            
            HStack {
                statCard(title: "High Yield", value: "\(highYieldCompleted)/\(highYieldTotal)", color: .red)
                statCard(title: "Avg Revision", value: "\(averageRevisionCount)", color: .orange)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func statCard(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title2)
                .bold()
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
    
    // MARK: - Computed Properties
    
    private var completedTopics: Int {
        topics.filter { $0.isCompleted }.count
    }
    
    private var highYieldTotal: Int {
        topics.filter { $0.yieldLevel == .high }.count
    }
    
    private var highYieldCompleted: Int {
        topics.filter { $0.yieldLevel == .high && $0.isCompleted }.count
    }
    
    private var averageRevisionCount: String {
        let total = topics.reduce(0) { $0 + $1.revisionCount }
        let average = topics.isEmpty ? 0.0 : Double(total) / Double(topics.count)
        return String(format: "%.1f", average)
    }
}
