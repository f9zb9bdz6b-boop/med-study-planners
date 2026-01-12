import Foundation
import SwiftData
import SwiftUI

// MARK: - Subject Enum
enum Subject: String, Codable, CaseIterable {
    case pharmacology
    case pathology
    case microbiology
    
    var color: Color {
        switch self {
        case .pharmacology:
            return .cyan
        case .pathology:
            return .purple
        case .microbiology:
            return .orange
        }
    }
}

// MARK: - Yield Enum
enum Yield: String, Codable, CaseIterable {
    case high
    case medium
    case low
    
    var weight: Double {
        switch self {
        case .high:
            return 2.0
        case .medium:
            return 1.0
        case .low:
            return 0.5
        }
    }
    
    var color: Color {
        switch self {
        case .high:
            return .red
        case .medium:
            return .yellow
        case .low:
            return .green
        }
    }
}

// MARK: - Topic Model
@Model
final class Topic {
    var id: UUID
    var name: String
    var subject: Subject
    var yieldLevel: Yield
    var systemCategory: String
    var isCompleted: Bool
    var completionDate: Date?
    var lastRevisionDate: Date?
    var revisionCount: Int
    
    // Specific fields
    var mnemonic: String
    var robbinsPageRef: String?
    var microGramStain: String?
    
    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \ChecklistItem.topic)
    var checklist: [ChecklistItem]
    
    @Relationship(deleteRule: .cascade, inverse: \Note.topic)
    var note: Note?
    
    init(
        id: UUID = UUID(),
        name: String,
        subject: Subject,
        yieldLevel: Yield,
        systemCategory: String,
        isCompleted: Bool = false,
        completionDate: Date? = nil,
        lastRevisionDate: Date? = nil,
        revisionCount: Int = 0,
        mnemonic: String = "",
        robbinsPageRef: String? = nil,
        microGramStain: String? = nil,
        checklist: [ChecklistItem] = [],
        note: Note? = nil
    ) {
        self.id = id
        self.name = name
        self.subject = subject
        self.yieldLevel = yieldLevel
        self.systemCategory = systemCategory
        self.isCompleted = isCompleted
        self.completionDate = completionDate
        self.lastRevisionDate = lastRevisionDate
        self.revisionCount = revisionCount
        self.mnemonic = mnemonic
        self.robbinsPageRef = robbinsPageRef
        self.microGramStain = microGramStain
        self.checklist = checklist
        self.note = note
    }
    
    // Logic: Topic cannot be marked done until all mandatory items are checked
    var canMarkAsDone: Bool {
        let mandatoryItems = checklist.filter { $0.isMandatory }
        return mandatoryItems.allSatisfy { $0.isChecked }
    }
}

// MARK: - ChecklistItem Model
@Model
final class ChecklistItem {
    var id: UUID
    var title: String
    var isChecked: Bool
    var isMandatory: Bool
    
    var topic: Topic?
    
    init(
        id: UUID = UUID(),
        title: String,
        isChecked: Bool = false,
        isMandatory: Bool = false
    ) {
        self.id = id
        self.title = title
        self.isChecked = isChecked
        self.isMandatory = isMandatory
    }
}

// MARK: - Note Model
@Model
final class Note {
    var id: UUID
    var explanationContent: String
    var examAnswerContent: String
    var isLMR: Bool
    
    var topic: Topic?
    
    init(
        id: UUID = UUID(),
        explanationContent: String = "",
        examAnswerContent: String = "",
        isLMR: Bool = false
    ) {
        self.id = id
        self.explanationContent = explanationContent
        self.examAnswerContent = examAnswerContent
        self.isLMR = isLMR
    }
}

// MARK: - StudyPlan Model
@Model
final class StudyPlan {
    var id: UUID
    var examName: String
    var examDate: Date
    var includedSystems: [String]
    
    @Relationship(deleteRule: .cascade, inverse: \DailyTask.studyPlan)
    var dailyTasks: [DailyTask]
    
    init(
        id: UUID = UUID(),
        examName: String,
        examDate: Date,
        includedSystems: [String] = [],
        dailyTasks: [DailyTask] = []
    ) {
        self.id = id
        self.examName = examName
        self.examDate = examDate
        self.includedSystems = includedSystems
        self.dailyTasks = dailyTasks
    }
}

// MARK: - DailyTask Model
@Model
final class DailyTask {
    var id: UUID
    var date: Date
    var isMissed: Bool
    
    // Store topic IDs as we can't directly relate to Topics in many-to-many
    var assignedTopicIDs: [UUID]
    
    var studyPlan: StudyPlan?
    
    init(
        id: UUID = UUID(),
        date: Date,
        assignedTopicIDs: [UUID] = [],
        isMissed: Bool = false
    ) {
        self.id = id
        self.date = date
        self.assignedTopicIDs = assignedTopicIDs
        self.isMissed = isMissed
    }
    
    // Helper to compute if task is missed
    func updateMissedStatus(topics: [Topic]) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let taskDay = calendar.startOfDay(for: date)
        
        if taskDay < today {
            let allCompleted = assignedTopicIDs.allSatisfy { topicID in
                topics.first(where: { $0.id == topicID })?.isCompleted ?? false
            }
            self.isMissed = !allCompleted
        } else {
            self.isMissed = false
        }
    }
}
