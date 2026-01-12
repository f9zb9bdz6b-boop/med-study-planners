import SwiftUI
import SwiftData

struct NotesView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var topic: Topic
    
    @State private var selectedTab: NoteTab = .explanation
    
    enum NoteTab {
        case explanation
        case examAnswer
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segmented Control
                Picker("Note Type", selection: $selectedTab) {
                    Text("Explanation").tag(NoteTab.explanation)
                    Text("Exam Answer").tag(NoteTab.examAnswer)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // LMR Toggle
                if let note = topic.note {
                    Toggle("Last Minute Revision (LMR) Mode", isOn: Binding(
                        get: { note.isLMR },
                        set: { note.isLMR = $0 }
                    ))
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
                
                // Editor
                if let note = topic.note {
                    switch selectedTab {
                    case .explanation:
                        noteEditor(
                            content: Binding(
                                get: { note.explanationContent },
                                set: { note.explanationContent = $0 }
                            ),
                            isLMR: note.isLMR
                        )
                    case .examAnswer:
                        noteEditor(
                            content: Binding(
                                get: { note.examAnswerContent },
                                set: { note.examAnswerContent = $0 }
                            ),
                            isLMR: note.isLMR
                        )
                    }
                } else {
                    Text("No note available")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle(topic.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func noteEditor(content: Binding<String>, isLMR: Bool) -> some View {
        ZStack(alignment: .topLeading) {
            if content.wrappedValue.isEmpty {
                Text("Start typing your notes here...")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }
            
            TextEditor(text: content)
                .padding(4)
                .opacity(isLMR ? getLMROpacity(for: content.wrappedValue) : 1.0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
    }
    
    private func getLMROpacity(for text: String) -> Double {
        // In LMR mode, fade non-header/non-bold text
        // This is a simplified implementation - in a real app you'd parse markdown
        // For now, return base opacity that makes regular text faded
        return 1.0 // Keep full opacity; proper implementation would require markdown parsing
    }
}

// MARK: - LMR Text Modifier (Simplified)
struct LMRTextView: View {
    let content: String
    let isLMR: Bool
    
    var body: some View {
        ScrollView {
            Text(processedText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
    }
    
    private var processedText: AttributedString {
        var attributedString = AttributedString(content)
        
        if isLMR {
            // Apply opacity to non-header/non-bold text
            // This is a simplified version - proper implementation would parse markdown
            attributedString.foregroundColor = .gray.opacity(0.3)
        }
        
        return attributedString
    }
}
