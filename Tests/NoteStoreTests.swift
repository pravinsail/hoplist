import XCTest
import Shared
@testable import HopList

@MainActor
final class NoteStoreTests: XCTestCase {
    var noteStore: MockNoteStore!
    
    override func setUp() {
        super.setUp()
        noteStore = MockNoteStore()
    }
    
    override func tearDown() {
        noteStore = nil
        super.tearDown()
    }
    
    func testAddNote() async throws {
        // Given
        let note = Note(title: "Test Note", content: "Test Content")
        
        // When
        try await noteStore.addNote(note)
        
        // Then
        XCTAssertEqual(noteStore.notes.count, 1)
        XCTAssertEqual(noteStore.notes.first?.title, "Test Note")
        XCTAssertEqual(noteStore.notes.first?.content, "Test Content")
    }
    
    func testUpdateNote() async throws {
        // Given
        let note = Note(title: "Original Title", content: "Original Content")
        try await noteStore.addNote(note)
        
        // When
        let updatedNote = Note(
            id: note.id,
            title: "Updated Title",
            content: "Updated Content",
            createdAt: note.createdAt,
            updatedAt: Date(),
            isCompleted: true
        )
        try await noteStore.updateNote(updatedNote)
        
        // Then
        XCTAssertEqual(noteStore.notes.count, 1)
        XCTAssertEqual(noteStore.notes.first?.title, "Updated Title")
        XCTAssertEqual(noteStore.notes.first?.content, "Updated Content")
        XCTAssertTrue(noteStore.notes.first?.isCompleted ?? false)
    }
    
    func testDeleteNote() async throws {
        // Given
        let note1 = Note(title: "Note 1", content: "Content 1")
        let note2 = Note(title: "Note 2", content: "Content 2")
        try await noteStore.addNote(note1)
        try await noteStore.addNote(note2)
        
        // When
        try await noteStore.deleteNote(note1)
        
        // Then
        XCTAssertEqual(noteStore.notes.count, 1)
        XCTAssertEqual(noteStore.notes.first?.title, "Note 2")
    }
    
    func testToggleNoteCompletion() async throws {
        // Given
        let note = Note(title: "Test Note", content: "Test Content", isCompleted: false)
        try await noteStore.addNote(note)
        
        // When
        try await noteStore.toggleNoteCompletion(note)
        
        // Then
        XCTAssertTrue(noteStore.notes.first?.isCompleted ?? false)
        
        // When toggling again
        try await noteStore.toggleNoteCompletion(note)
        
        // Then
        XCTAssertFalse(noteStore.notes.first?.isCompleted ?? true)
    }
    
    func testFetchNotes() async throws {
        // Given
        let note1 = Note(title: "Note 1", content: "Content 1")
        let note2 = Note(title: "Note 2", content: "Content 2")
        try await noteStore.addNote(note1)
        try await noteStore.addNote(note2)
        
        // When
        let fetchedNotes = try await noteStore.fetchNotes()
        
        // Then
        XCTAssertEqual(fetchedNotes.count, 2)
        XCTAssertEqual(fetchedNotes.map { $0.title }, ["Note 1", "Note 2"])
    }
    
    func testNotesPublisher() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Publisher should emit notes")
        var receivedNotes: [Note] = []
        
        let cancellable = noteStore.notesPublisher
            .sink { notes in
                receivedNotes = notes
                expectation.fulfill()
            }
        
        // When
        let note = Note(title: "Test Note", content: "Test Content")
        try await noteStore.addNote(note)
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedNotes.count, 1)
        XCTAssertEqual(receivedNotes.first?.title, "Test Note")
        
        cancellable.cancel()
    }
}
