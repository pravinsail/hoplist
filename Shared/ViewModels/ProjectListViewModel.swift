import Foundation
import Combine

@MainActor
public class ProjectListViewModel: ObservableObject {
    @Published public var projects: [Project] = []
    @Published public var searchText: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private let projectStore: ProjectStore
    private var cancellables = Set<AnyCancellable>()
    
    public init(projectStore: ProjectStore) {
        self.projectStore = projectStore
        setupBindings()
    }
    
    private func setupBindings() {
        // Bind to project store
        projectStore.projectsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.projects, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Computed Properties
    public var filteredProjects: [Project] {
        if searchText.isEmpty {
            return projects
        } else {
            return projects.filter { project in
                project.name.localizedCaseInsensitiveContains(searchText) ||
                project.description?.localizedCaseInsensitiveContains(searchText) == true ||
                project.members.contains { member in
                    member.name.localizedCaseInsensitiveContains(searchText) ||
                    member.role.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    }
    
    public var completedProjects: [Project] {
        filteredProjects.filter { project in
            !project.milestones.isEmpty && project.milestones.allSatisfy { $0.isDone }
        }
    }
    
    public var activeProjects: [Project] {
        filteredProjects.filter { project in
            project.milestones.isEmpty || !project.milestones.allSatisfy { $0.isDone }
        }
    }
    
    // MARK: - Project Operations
    public func addProject(name: String, description: String? = nil) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let project = Project(name: name, description: description)
            try await projectStore.addProject(project)
        } catch {
            errorMessage = "Failed to add project: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    public func updateProject(_ project: Project) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await projectStore.updateProject(project)
        } catch {
            errorMessage = "Failed to update project: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    public func deleteProject(_ project: Project) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await projectStore.deleteProject(project)
        } catch {
            errorMessage = "Failed to delete project: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Milestone Operations
    public func addMilestone(title: String, due: Date? = nil, to project: Project) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let milestone = Milestone(title: title, due: due)
            try await projectStore.addMilestone(milestone, to: project)
        } catch {
            errorMessage = "Failed to add milestone: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    public func toggleMilestone(_ milestone: Milestone, in project: Project) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await projectStore.toggleMilestone(milestone, in: project)
        } catch {
            errorMessage = "Failed to toggle milestone: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    public func deleteMilestone(_ milestone: Milestone, from project: Project) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await projectStore.deleteMilestone(milestone, from: project)
        } catch {
            errorMessage = "Failed to delete milestone: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Team Member Operations
    public func addMember(name: String, role: String, to project: Project) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let member = TeamMember(name: name, role: role)
            try await projectStore.addMember(member, to: project)
        } catch {
            errorMessage = "Failed to add team member: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    public func updateMember(_ member: TeamMember, in project: Project) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await projectStore.updateMember(member, in: project)
        } catch {
            errorMessage = "Failed to update team member: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    public func deleteMember(_ member: TeamMember, from project: Project) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await projectStore.deleteMember(member, from: project)
        } catch {
            errorMessage = "Failed to delete team member: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Utility Methods
    public func clearError() {
        errorMessage = nil
    }
    
    public func clearSearch() {
        searchText = ""
    }
}
