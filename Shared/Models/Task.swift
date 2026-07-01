import Foundation
import SwiftData

@Model
public class Task {
    public var id: UUID
    public var title: String
    public var description: String
    public var priority: TaskPriority
    public var dueDate: Date?
    public var isCompleted: Bool
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        priority: TaskPriority = .medium,
        dueDate: Date? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.priority = priority
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Task Priority
public enum TaskPriority: Int, CaseIterable, Codable {
    case low = 0
    case medium = 1
    case high = 2
    case urgent = 3
    
    public var displayName: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .urgent: return "Urgent"
        }
    }
    
    public var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "blue"
        case .high: return "orange"
        case .urgent: return "red"
        }
    }
}

// MARK: - Identifiable
extension Task: Identifiable {}

// MARK: - Equatable
extension Task: Equatable {
    public static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension Task: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Computed Properties
extension Task {
    public var isOverdue: Bool {
        guard let dueDate = dueDate else { return false }
        return !isCompleted && dueDate < Date()
    }
    
    public var daysUntilDue: Int? {
        guard let dueDate = dueDate else { return nil }
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: Date(), to: dueDate).day
    }
}
