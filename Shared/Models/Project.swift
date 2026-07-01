import Foundation
import SwiftData

@Model
public class Project {
    public var id: UUID
    public var name: String
    public var description: String?
    public var milestones: [Milestone]
    public var members: [TeamMember]
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String? = nil,
        milestones: [Milestone] = [],
        members: [TeamMember] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.milestones = milestones
        self.members = members
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

@Model
public class Milestone {
    public var id: UUID
    public var title: String
    public var due: Date?
    public var isDone: Bool
    
    public init(
        id: UUID = UUID(),
        title: String,
        due: Date? = nil,
        isDone: Bool = false
    ) {
        self.id = id
        self.title = title
        self.due = due
        self.isDone = isDone
    }
}

@Model
public class TeamMember {
    public var id: UUID
    public var name: String
    public var role: String
    
    public init(
        id: UUID = UUID(),
        name: String,
        role: String
    ) {
        self.id = id
        self.name = name
        self.role = role
    }
}

// MARK: - Identifiable
extension Project: Identifiable {}
extension Milestone: Identifiable {}
extension TeamMember: Identifiable {}

// MARK: - Equatable
extension Project: Equatable {
    public static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id
    }
}

extension Milestone: Equatable {
    public static func == (lhs: Milestone, rhs: Milestone) -> Bool {
        lhs.id == rhs.id
    }
}

extension TeamMember: Equatable {
    public static func == (lhs: TeamMember, rhs: TeamMember) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension Project: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Milestone: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TeamMember: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
