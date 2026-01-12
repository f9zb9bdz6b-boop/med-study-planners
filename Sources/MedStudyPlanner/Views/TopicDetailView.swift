import SwiftUI
import SwiftData

struct TopicDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var topic: Topic
    
    @State private var showNotes = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Circle()
                            .fill(topic.yieldLevel.color)
                            .frame(width: 20, height: 20)
                        Text(topic.yieldLevel.rawValue.capitalized + " Yield")
                            .font(.headline)
                    }
                    Text(topic.subject.rawValue.capitalized)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                
                // Mnemonic Vault
                VStack(alignment: .leading, spacing: 8) {
                    Text("Mnemonic Vault")
                        .font(.headline)
                    TextField("Enter mnemonic...", text: $topic.mnemonic, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                }
                .padding()
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Resource Checklist
                VStack(alignment: .leading, spacing: 12) {
                    Text("Resource Checklist")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(getChecklistItems(), id: \.title) { item in
                        checklistRow(item: item)
                    }
                }
                
                // Subject-specific fields
                if topic.subject == .pathology {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Robbins Page Reference")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        TextField("Page number...", text: Binding(
                            get: { topic.robbinsPageRef ?? "" },
                            set: { topic.robbinsPageRef = $0.isEmpty ? nil : $0 }
                        ))
                        .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal)
                }
                
                if topic.subject == .microbiology {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gram Stain")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        TextField("Gram stain result...", text: Binding(
                            get: { topic.microGramStain ?? "" },
                            set: { topic.microGramStain = $0.isEmpty ? nil : $0 }
                        ))
                        .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal)
                }
                
                // Action Buttons
                HStack(spacing: 16) {
                    Button {
                        // Atlas action (placeholder)
                    } label: {
                        HStack {
                            Image(systemName: "photo.stack")
                            Text("Atlas")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                    }
                    
                    Button {
                        showNotes = true
                    } label: {
                        HStack {
                            Image(systemName: "note.text")
                            Text("Notes")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                // Completion Status
                if topic.isCompleted {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Completed")
                            .font(.headline)
                            .foregroundStyle(.green)
                        if let date = topic.completionDate {
                            Text(date, style: .date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(topic.name)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showNotes) {
            NotesView(topic: topic)
        }
        .onAppear {
            ensureChecklistItemsExist()
            ensureNoteExists()
        }
    }
    
    private func getChecklistItems() -> [ChecklistItemData] {
        switch topic.subject {
        case .pharmacology:
            return [
                ChecklistItemData(title: "Video", isMandatory: false),
                ChecklistItemData(title: "KDT", isMandatory: false),
                ChecklistItemData(title: "Classification Chart", isMandatory: false)
            ]
        case .pathology:
            return [
                ChecklistItemData(title: "Video", isMandatory: false),
                ChecklistItemData(title: "Robbins", isMandatory: false),
                ChecklistItemData(title: "Morphology", isMandatory: true),
                ChecklistItemData(title: "Pathogenesis", isMandatory: true)
            ]
        case .microbiology:
            return [
                ChecklistItemData(title: "Lab Diagnosis", isMandatory: false),
                ChecklistItemData(title: "Virulence", isMandatory: false),
                ChecklistItemData(title: "Culture", isMandatory: false)
            ]
        }
    }
    
    private func checklistRow(item: ChecklistItemData) -> some View {
        let existingItem = topic.checklist.first { $0.title == item.title }
        
        return HStack {
            Button {
                toggleChecklistItem(item: item)
            } label: {
                Image(systemName: existingItem?.isChecked == true ? "checkmark.square.fill" : "square")
                    .foregroundStyle(existingItem?.isChecked == true ? .green : .secondary)
                    .font(.title3)
            }
            .buttonStyle(.plain)
            
            Text(item.title)
            
            if item.isMandatory {
                Text("*")
                    .foregroundStyle(.red)
                    .bold()
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private func ensureChecklistItemsExist() {
        let requiredItems = getChecklistItems()
        
        for itemData in requiredItems {
            if !topic.checklist.contains(where: { $0.title == itemData.title }) {
                let newItem = ChecklistItem(
                    title: itemData.title,
                    isChecked: false,
                    isMandatory: itemData.isMandatory
                )
                topic.checklist.append(newItem)
                modelContext.insert(newItem)
            }
        }
        
        try? modelContext.save()
    }
    
    private func ensureNoteExists() {
        if topic.note == nil {
            let newNote = Note()
            topic.note = newNote
            modelContext.insert(newNote)
            try? modelContext.save()
        }
    }
    
    private func toggleChecklistItem(item: ChecklistItemData) {
        if let existingItem = topic.checklist.first(where: { $0.title == item.title }) {
            existingItem.isChecked.toggle()
            try? modelContext.save()
        }
    }
}

struct ChecklistItemData {
    let title: String
    let isMandatory: Bool
}
