import SwiftUI
import SwiftData

struct SubjectListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Topic.name) private var topics: [Topic]
    
    @State private var selectedSubject: Subject = .pharmacology
    @State private var pathologyFilter: PathologyFilter = .general
    
    enum PathologyFilter: String, CaseIterable {
        case general = "GENERAL"
        case systemic = "SYSTEMIC"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Subject Picker
                Picker("Subject", selection: $selectedSubject) {
                    ForEach(Subject.allCases, id: \.self) { subject in
                        Text(subject.rawValue.capitalized)
                            .tag(subject)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Pathology-specific filter
                if selectedSubject == .pathology {
                    Picker("Type", selection: $pathologyFilter) {
                        ForEach(PathologyFilter.allCases, id: \.self) { filter in
                            Text(filter.rawValue)
                                .tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
                
                // Topics List
                if filteredTopics.isEmpty {
                    emptyStateView
                } else {
                    topicsList
                }
            }
            .navigationTitle("Topics")
        }
    }
    
    private var filteredTopics: [Topic] {
        let subjectFiltered = topics.filter { $0.subject == selectedSubject }
        
        if selectedSubject == .pathology {
            switch pathologyFilter {
            case .general:
                return subjectFiltered.filter { 
                    $0.systemCategory == "General" || 
                    $0.systemCategory == "Hemodynamics" || 
                    $0.systemCategory == "Neoplasia" 
                }
            case .systemic:
                return subjectFiltered.filter { $0.systemCategory == "Systemic" }
            }
        }
        
        return subjectFiltered
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("No topics available")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var topicsList: some View {
        List {
            ForEach(groupedTopics.keys.sorted(), id: \.self) { category in
                DisclosureGroup {
                    ForEach(groupedTopics[category] ?? [], id: \.id) { topic in
                        NavigationLink(destination: TopicDetailView(topic: topic)) {
                            topicRow(topic: topic)
                        }
                    }
                } label: {
                    HStack {
                        Text(category)
                            .font(.headline)
                        Spacer()
                        Text("\(groupedTopics[category]?.count ?? 0)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private func topicRow(topic: Topic) -> some View {
        HStack(spacing: 12) {
            // Checkbox
            Button {
                toggleCompletion(topic: topic)
            } label: {
                Image(systemName: topic.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(topic.isCompleted ? .green : .secondary)
                    .font(.title3)
            }
            .buttonStyle(.plain)
            
            // Topic Name
            Text(topic.name)
                .strikethrough(topic.isCompleted)
            
            Spacer()
            
            // Yield Badge
            Circle()
                .fill(topic.yieldLevel.color)
                .frame(width: 16, height: 16)
                .overlay(
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2)
                )
        }
    }
    
    private var groupedTopics: [String: [Topic]] {
        Dictionary(grouping: filteredTopics) { topic in
            topic.systemCategory
        }
    }
    
    private func toggleCompletion(topic: Topic) {
        if !topic.isCompleted {
            // Check if all mandatory items are checked
            if topic.canMarkAsDone {
                topic.isCompleted = true
                topic.completionDate = Date()
                topic.lastRevisionDate = Date()
            }
        } else {
            topic.isCompleted = false
            topic.completionDate = nil
        }
        try? modelContext.save()
    }
}
