import Foundation
import SwiftData

@Model
public class Note {
    public var id: UUID
    public var title: String
    public var content: String
    public var createdAt: Date
    public var updatedAt: Date
    public var isCompleted: Bool
    
    public init(
        id: UUID = UUID(),
        title: String,
        content: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isCompleted = isCompleted
    }
}

// MARK: - Identifiable
extension Note: Identifiable {}

// MARK: - Equatable
extension Note: Equatable {
    public static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension Note: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
