import Foundation
import SwiftData
import Combine

// MARK: - TaskStore Protocol
public protocol TaskStore: ObservableObject {
    var tasks: [Task] { get }
    var tasksPublisher: AnyPublisher<[Task], Never> { get }
    
    func addTask(_ task: Task) async throws
    func updateTask(_ task: Task) async throws
    func deleteTask(_ task: Task) async throws
    func fetchTasks() async throws -> [Task]
    func toggleTaskCompletion(_ task: Task) async throws
    func fetchTasksByPriority(_ priority: TaskPriority) async throws -> [Task]
    func fetchOverdueTasks() async throws -> [Task]
}

// MARK: - TaskStore Implementation
@MainActor
public class SwiftDataTaskStore: TaskStore {
    private let modelContext: ModelContext
    private let tasksSubject = CurrentValueSubject<[Task], Never>([])
    
    public var tasks: [Task] {
        tasksSubject.value
    }
    
    public var tasksPublisher: AnyPublisher<[Task], Never> {
        tasksSubject.eraseToAnyPublisher()
    }
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        Task {
            await loadTasks()
        }
    }
    
    public func addTask(_ task: Task) async throws {
        modelContext.insert(task)
        try modelContext.save()
        await loadTasks()
    }
    
    public func updateTask(_ task: Task) async throws {
        task.updatedAt = Date()
        try modelContext.save()
        await loadTasks()
    }
    
    public func deleteTask(_ task: Task) async throws {
        modelContext.delete(task)
        try modelContext.save()
        await loadTasks()
    }
    
    public func fetchTasks() async throws -> [Task] {
        let descriptor = FetchDescriptor<Task>(
            sortBy: [
                SortDescriptor(\.priority, order: .reverse),
                SortDescriptor(\.dueDate, order: .forward),
                SortDescriptor(\.updatedAt, order: .reverse)
            ]
        )
        return try modelContext.fetch(descriptor)
    }
    
    public func toggleTaskCompletion(_ task: Task) async throws {
        task.isCompleted.toggle()
        task.updatedAt = Date()
        try modelContext.save()
        await loadTasks()
    }
    
    public func fetchTasksByPriority(_ priority: TaskPriority) async throws -> [Task] {
        let descriptor = FetchDescriptor<Task>(
            predicate: #Predicate<Task> { task in
                task.priority == priority
            },
            sortBy: [
                SortDescriptor(\.dueDate, order: .forward),
                SortDescriptor(\.updatedAt, order: .reverse)
            ]
        )
        return try modelContext.fetch(descriptor)
    }
    
    public func fetchOverdueTasks() async throws -> [Task] {
        let now = Date()
        let descriptor = FetchDescriptor<Task>(
            predicate: #Predicate<Task> { task in
                task.dueDate != nil && task.dueDate! < now && !task.isCompleted
            },
            sortBy: [
                SortDescriptor(\.dueDate, order: .forward),
                SortDescriptor(\.priority, order: .reverse)
            ]
        )
        return try modelContext.fetch(descriptor)
    }
    
    private func loadTasks() async {
        do {
            let fetchedTasks = try await fetchTasks()
            tasksSubject.send(fetchedTasks)
        } catch {
            print("Error loading tasks: \(error)")
            tasksSubject.send([])
        }
    }
}

// MARK: - Mock TaskStore for Testing
public class MockTaskStore: TaskStore {
    private let tasksSubject = CurrentValueSubject<[Task], Never>([])
    
    public var tasks: [Task] {
        tasksSubject.value
    }
    
    public var tasksPublisher: AnyPublisher<[Task], Never> {
        tasksSubject.eraseToAnyPublisher()
    }
    
    public init(initialTasks: [Task] = []) {
        tasksSubject.send(initialTasks)
    }
    
    public func addTask(_ task: Task) async throws {
        var currentTasks = tasksSubject.value
        currentTasks.append(task)
        tasksSubject.send(currentTasks)
    }
    
    public func updateTask(_ task: Task) async throws {
        var currentTasks = tasksSubject.value
        if let index = currentTasks.firstIndex(where: { $0.id == task.id }) {
            currentTasks[index] = task
            tasksSubject.send(currentTasks)
        }
    }
    
    public func deleteTask(_ task: Task) async throws {
        var currentTasks = tasksSubject.value
        currentTasks.removeAll { $0.id == task.id }
        tasksSubject.send(currentTasks)
    }
    
    public func fetchTasks() async throws -> [Task] {
        return tasksSubject.value
    }
    
    public func toggleTaskCompletion(_ task: Task) async throws {
        var currentTasks = tasksSubject.value
        if let index = currentTasks.firstIndex(where: { $0.id == task.id }) {
            currentTasks[index].isCompleted.toggle()
            currentTasks[index].updatedAt = Date()
            tasksSubject.send(currentTasks)
        }
    }
    
    public func fetchTasksByPriority(_ priority: TaskPriority) async throws -> [Task] {
        return tasksSubject.value.filter { $0.priority == priority }
    }
    
    public func fetchOverdueTasks() async throws -> [Task] {
        return tasksSubject.value.filter { $0.isOverdue }
    }
}
