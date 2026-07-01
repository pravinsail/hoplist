import Foundation
import SwiftData
import Combine

// MARK: - NoteStore Protocol
public protocol NoteStore: ObservableObject {
    var notes: [Note] { get }
    var notesPublisher: AnyPublisher<[Note], Never> { get }
    
    func addNote(_ note: Note) async throws
    func updateNote(_ note: Note) async throws
    func deleteNote(_ note: Note) async throws
    func fetchNotes() async throws -> [Note]
    func toggleNoteCompletion(_ note: Note) async throws
}

// MARK: - NoteStore Implementation
@MainActor
public class SwiftDataNoteStore: NoteStore {
    private let modelContext: ModelContext
    private let notesSubject = CurrentValueSubject<[Note], Never>([])
    
    public var notes: [Note] {
        notesSubject.value
    }
    
    public var notesPublisher: AnyPublisher<[Note], Never> {
        notesSubject.eraseToAnyPublisher()
    }
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        Task {
            await loadNotes()
        }
    }
    
    public func addNote(_ note: Note) async throws {
        modelContext.insert(note)
        try modelContext.save()
        await loadNotes()
    }
    
    public func updateNote(_ note: Note) async throws {
        note.updatedAt = Date()
        try modelContext.save()
        await loadNotes()
    }
    
    public func deleteNote(_ note: Note) async throws {
        modelContext.delete(note)
        try modelContext.save()
        await loadNotes()
    }
    
    public func fetchNotes() async throws -> [Note] {
        let descriptor = FetchDescriptor<Note>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    public func toggleNoteCompletion(_ note: Note) async throws {
        note.isCompleted.toggle()
        note.updatedAt = Date()
        try modelContext.save()
        await loadNotes()
    }
    
    private func loadNotes() async {
        do {
            let fetchedNotes = try await fetchNotes()
            notesSubject.send(fetchedNotes)
        } catch {
            print("Error loading notes: \(error)")
            notesSubject.send([])
        }
    }
}

// MARK: - Mock NoteStore for Testing
public class MockNoteStore: NoteStore {
    private let notesSubject = CurrentValueSubject<[Note], Never>([])
    
    public var notes: [Note] {
        notesSubject.value
    }
    
    public var notesPublisher: AnyPublisher<[Note], Never> {
        notesSubject.eraseToAnyPublisher()
    }
    
    public init(initialNotes: [Note] = []) {
        notesSubject.send(initialNotes)
    }
    
    public func addNote(_ note: Note) async throws {
        var currentNotes = notesSubject.value
        currentNotes.append(note)
        notesSubject.send(currentNotes)
    }
    
    public func updateNote(_ note: Note) async throws {
        var currentNotes = notesSubject.value
        if let index = currentNotes.firstIndex(where: { $0.id == note.id }) {
            currentNotes[index] = note
            notesSubject.send(currentNotes)
        }
    }
    
    public func deleteNote(_ note: Note) async throws {
        var currentNotes = notesSubject.value
        currentNotes.removeAll { $0.id == note.id }
        notesSubject.send(currentNotes)
    }
    
    public func fetchNotes() async throws -> [Note] {
        return notesSubject.value
    }
    
    public func toggleNoteCompletion(_ note: Note) async throws {
        var currentNotes = notesSubject.value
        if let index = currentNotes.firstIndex(where: { $0.id == note.id }) {
            currentNotes[index].isCompleted.toggle()
            currentNotes[index].updatedAt = Date()
            notesSubject.send(currentNotes)
        }
    }
}
