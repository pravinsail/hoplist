import Foundation
import SwiftData
import Combine

// MARK: - ProjectStore Protocol
public protocol ProjectStore: ObservableObject {
    var projects: [Project] { get }
    var projectsPublisher: AnyPublisher<[Project], Never> { get }
    
    func addProject(_ project: Project) async throws
    func updateProject(_ project: Project) async throws
    func deleteProject(_ project: Project) async throws
    func fetchProjects() async throws -> [Project]
    func fetchProject(by id: UUID) async throws -> Project?
    
    // Milestone operations
    func addMilestone(_ milestone: Milestone, to project: Project) async throws
    func updateMilestone(_ milestone: Milestone, in project: Project) async throws
    func deleteMilestone(_ milestone: Milestone, from project: Project) async throws
    func toggleMilestone(_ milestone: Milestone, in project: Project) async throws
    
    // Team member operations
    func addMember(_ member: TeamMember, to project: Project) async throws
    func updateMember(_ member: TeamMember, in project: Project) async throws
    func deleteMember(_ member: TeamMember, from project: Project) async throws
}

// MARK: - SwiftData ProjectStore Implementation
@MainActor
public class SwiftDataProjectStore: ProjectStore {
    private let modelContext: ModelContext
    private let projectsSubject = CurrentValueSubject<[Project], Never>([])
    
    public var projects: [Project] {
        projectsSubject.value
    }
    
    public var projectsPublisher: AnyPublisher<[Project], Never> {
        projectsSubject.eraseToAnyPublisher()
    }
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        Task {
            await loadProjects()
        }
    }
    
    public func addProject(_ project: Project) async throws {
        modelContext.insert(project)
        try modelContext.save()
        await loadProjects()
    }
    
    public func updateProject(_ project: Project) async throws {
        project.updatedAt = Date()
        try modelContext.save()
        await loadProjects()
    }
    
    public func deleteProject(_ project: Project) async throws {
        modelContext.delete(project)
        try modelContext.save()
        await loadProjects()
    }
    
    public func fetchProjects() async throws -> [Project] {
        let descriptor = FetchDescriptor<Project>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    public func fetchProject(by id: UUID) async throws -> Project? {
        let descriptor = FetchDescriptor<Project>(
            predicate: #Predicate<Project> { project in
                project.id == id
            }
        )
        return try modelContext.fetch(descriptor).first
    }
    
    // MARK: - Milestone Operations
    public func addMilestone(_ milestone: Milestone, to project: Project) async throws {
        project.milestones.append(milestone)
        project.updatedAt = Date()
        try modelContext.save()
        await loadProjects()
    }
    
    public func updateMilestone(_ milestone: Milestone, in project: Project) async throws {
        if let index = project.milestones.firstIndex(where: { $0.id == milestone.id }) {
            project.milestones[index] = milestone
            project.updatedAt = Date()
            try modelContext.save()
            await loadProjects()
        }
    }
    
    public func deleteMilestone(_ milestone: Milestone, from project: Project) async throws {
        project.milestones.removeAll { $0.id == milestone.id }
        project.updatedAt = Date()
        try modelContext.save()
        await loadProjects()
    }
    
    public func toggleMilestone(_ milestone: Milestone, in project: Project) async throws {
        if let index = project.milestones.firstIndex(where: { $0.id == milestone.id }) {
            project.milestones[index].isDone.toggle()
            project.updatedAt = Date()
            try modelContext.save()
            await loadProjects()
        }
    }
    
    // MARK: - Team Member Operations
    public func addMember(_ member: TeamMember, to project: Project) async throws {
        project.members.append(member)
        project.updatedAt = Date()
        try modelContext.save()
        await loadProjects()
    }
    
    public func updateMember(_ member: TeamMember, in project: Project) async throws {
        if let index = project.members.firstIndex(where: { $0.id == member.id }) {
            project.members[index] = member
            project.updatedAt = Date()
            try modelContext.save()
            await loadProjects()
        }
    }
    
    public func deleteMember(_ member: TeamMember, from project: Project) async throws {
        project.members.removeAll { $0.id == member.id }
        project.updatedAt = Date()
        try modelContext.save()
        await loadProjects()
    }
    
    private func loadProjects() async {
        do {
            let fetchedProjects = try await fetchProjects()
            projectsSubject.send(fetchedProjects)
        } catch {
            print("Error loading projects: \(error)")
            projectsSubject.send([])
        }
    }
}

// MARK: - In-Memory ProjectStore Implementation
public class InMemoryProjectStore: ProjectStore {
    private let projectsSubject = CurrentValueSubject<[Project], Never>([])
    
    public var projects: [Project] {
        projectsSubject.value
    }
    
    public var projectsPublisher: AnyPublisher<[Project], Never> {
        projectsSubject.eraseToAnyPublisher()
    }
    
    public init(initialProjects: [Project] = []) {
        projectsSubject.send(initialProjects)
    }
    
    public func addProject(_ project: Project) async throws {
        var currentProjects = projectsSubject.value
        currentProjects.append(project)
        projectsSubject.send(currentProjects)
    }
    
    public func updateProject(_ project: Project) async throws {
        var currentProjects = projectsSubject.value
        if let index = currentProjects.firstIndex(where: { $0.id == project.id }) {
            currentProjects[index] = project
            projectsSubject.send(currentProjects)
        }
    }
    
    public func deleteProject(_ project: Project) async throws {
        var currentProjects = projectsSubject.value
        currentProjects.removeAll { $0.id == project.id }
        projectsSubject.send(currentProjects)
    }
    
    public func fetchProjects() async throws -> [Project] {
        return projectsSubject.value
    }
    
    public func fetchProject(by id: UUID) async throws -> Project? {
        return projectsSubject.value.first { $0.id == id }
    }
    
    // MARK: - Milestone Operations
    public func addMilestone(_ milestone: Milestone, to project: Project) async throws {
        var currentProjects = projectsSubject.value
        if let index = currentProjects.firstIndex(where: { $0.id == project.id }) {
            currentProjects[index].milestones.append(milestone)
            currentProjects[index].updatedAt = Date()
            projectsSubject.send(currentProjects)
        }
    }
    
    public func updateMilestone(_ milestone: Milestone, in project: Project) async throws {
        var currentProjects = projectsSubject.value
        if let projectIndex = currentProjects.firstIndex(where: { $0.id == project.id }),
           let milestoneIndex = currentProjects[projectIndex].milestones.firstIndex(where: { $0.id == milestone.id }) {
            currentProjects[projectIndex].milestones[milestoneIndex] = milestone
            currentProjects[projectIndex].updatedAt = Date()
            projectsSubject.send(currentProjects)
        }
    }
    
    public func deleteMilestone(_ milestone: Milestone, from project: Project) async throws {
        var currentProjects = projectsSubject.value
        if let projectIndex = currentProjects.firstIndex(where: { $0.id == project.id }) {
            currentProjects[projectIndex].milestones.removeAll { $0.id == milestone.id }
            currentProjects[projectIndex].updatedAt = Date()
            projectsSubject.send(currentProjects)
        }
    }
    
    public func toggleMilestone(_ milestone: Milestone, in project: Project) async throws {
        var currentProjects = projectsSubject.value
        if let projectIndex = currentProjects.firstIndex(where: { $0.id == project.id }),
           let milestoneIndex = currentProjects[projectIndex].milestones.firstIndex(where: { $0.id == milestone.id }) {
            currentProjects[projectIndex].milestones[milestoneIndex].isDone.toggle()
            currentProjects[projectIndex].updatedAt = Date()
            projectsSubject.send(currentProjects)
        }
    }
    
    // MARK: - Team Member Operations
    public func addMember(_ member: TeamMember, to project: Project) async throws {
        var currentProjects = projectsSubject.value
        if let index = currentProjects.firstIndex(where: { $0.id == project.id }) {
            currentProjects[index].members.append(member)
            currentProjects[index].updatedAt = Date()
            projectsSubject.send(currentProjects)
        }
    }
    
    public func updateMember(_ member: TeamMember, in project: Project) async throws {
        var currentProjects = projectsSubject.value
        if let projectIndex = currentProjects.firstIndex(where: { $0.id == project.id }),
           let memberIndex = currentProjects[projectIndex].members.firstIndex(where: { $0.id == member.id }) {
            currentProjects[projectIndex].members[memberIndex] = member
            currentProjects[projectIndex].updatedAt = Date()
            projectsSubject.send(currentProjects)
        }
    }
    
    public func deleteMember(_ member: TeamMember, from project: Project) async throws {
        var currentProjects = projectsSubject.value
        if let projectIndex = currentProjects.firstIndex(where: { $0.id == project.id }) {
            currentProjects[projectIndex].members.removeAll { $0.id == member.id }
            currentProjects[projectIndex].updatedAt = Date()
            projectsSubject.send(currentProjects)
        }
    }
}
