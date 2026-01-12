import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Query private var topics: [Topic]
    
    @AppStorage("forceDarkMode") private var forceDarkMode = false
    @AppStorage("fontSize") private var fontSize: Double = 1.0
    
    @State private var showExportSheet = false
    @State private var showResetAlert = false
    @State private var exportData = ""
    
    var body: some View {
        NavigationStack {
            Form {
                // Visuals Section
                Section("Visuals") {
                    Toggle("Force Dark Mode", isOn: $forceDarkMode)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Font Size")
                        HStack {
                            Text("A")
                                .font(.caption)
                            Slider(value: $fontSize, in: 0.8...1.5, step: 0.1)
                            Text("A")
                                .font(.title)
                        }
                    }
                }
                
                // Data Section
                Section("Data") {
                    Button {
                        prepareExportData()
                        showExportSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Export JSON")
                            Spacer()
                        }
                    }
                    
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset Progress")
                            Spacer()
                        }
                    }
                }
                
                // About Section
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Total Topics")
                        Spacer()
                        Text("\(topics.count)")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Completed")
                        Spacer()
                        Text("\(completedCount)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Reset Progress", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetProgress()
                }
            } message: {
                Text("This will reset completion status for all topics. This action cannot be undone.")
            }
            .sheet(isPresented: $showExportSheet) {
                ShareSheet(items: [exportData])
            }
        }
        .environment(\.dynamicTypeSize, dynamicTypeSizeForFontSize(fontSize))
        .preferredColorScheme(forceDarkMode ? .dark : nil)
    }
    
    private var completedCount: Int {
        topics.filter { $0.isCompleted }.count
    }
    
    private func prepareExportData() {
        var exportDict: [[String: Any]] = []
        
        for topic in topics {
            var topicDict: [String: Any] = [
                "id": topic.id.uuidString,
                "name": topic.name,
                "subject": topic.subject.rawValue,
                "yieldLevel": topic.yieldLevel.rawValue,
                "systemCategory": topic.systemCategory,
                "isCompleted": topic.isCompleted,
                "revisionCount": topic.revisionCount,
                "mnemonic": topic.mnemonic
            ]
            
            if let completionDate = topic.completionDate {
                topicDict["completionDate"] = ISO8601DateFormatter().string(from: completionDate)
            }
            
            if let lastRevisionDate = topic.lastRevisionDate {
                topicDict["lastRevisionDate"] = ISO8601DateFormatter().string(from: lastRevisionDate)
            }
            
            if let robbinsPageRef = topic.robbinsPageRef {
                topicDict["robbinsPageRef"] = robbinsPageRef
            }
            
            if let microGramStain = topic.microGramStain {
                topicDict["microGramStain"] = microGramStain
            }
            
            exportDict.append(topicDict)
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: exportDict, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            exportData = jsonString
        } else {
            exportData = "{\"error\": \"Failed to export data\"}"
        }
    }
    
    private func resetProgress() {
        for topic in topics {
            topic.isCompleted = false
            topic.completionDate = nil
        }
        
        try? modelContext.save()
    }
    
    private func dynamicTypeSizeForFontSize(_ size: Double) -> DynamicTypeSize {
        switch size {
        case 0.8..<0.9:
            return .small
        case 0.9..<1.0:
            return .medium
        case 1.0..<1.2:
            return .large
        case 1.2..<1.4:
            return .xLarge
        default:
            return .xxLarge
        }
    }
}

// MARK: - ShareSheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
