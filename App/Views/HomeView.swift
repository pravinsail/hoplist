import SwiftUI
import Shared

public struct HomeView: View {
    @ObservedObject var noteStore: NoteStore
    @State private var showingAddNote = false
    @State private var selectedNote: Note?
    
    public init(noteStore: NoteStore) {
        self.noteStore = noteStore
    }
    
    public var body: some View {
        #if os(iOS)
        iOSHomeView()
        #elseif os(macOS)
        macOSHomeView()
        #endif
    }
    
    // MARK: - iOS Layout
    @ViewBuilder
    private func iOSHomeView() -> some View {
        NavigationView {
            List {
                ForEach(noteStore.notes) { note in
                    NoteRowView(note: note, noteStore: noteStore)
                        .onTapGesture {
                            selectedNote = note
                        }
                }
                .onDelete(perform: deleteNotes)
            }
            .navigationTitle("HopList")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddNote = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView(noteStore: noteStore)
            }
            .sheet(item: $selectedNote) { note in
                NoteDetailView(note: note, noteStore: noteStore)
            }
        }
    }
    
    // MARK: - macOS Layout
    @ViewBuilder
    private func macOSHomeView() -> some View {
        NavigationSplitView {
            List(selection: $selectedNote) {
                ForEach(noteStore.notes) { note in
                    NoteRowView(note: note, noteStore: noteStore)
                        .tag(note)
                }
                .onDelete(perform: deleteNotes)
            }
            .navigationTitle("HopList")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddNote = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        } detail: {
            if let selectedNote = selectedNote {
                NoteDetailView(note: selectedNote, noteStore: noteStore)
            } else {
                Text("Select a note to view details")
                    .foregroundColor(.secondary)
            }
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteView(noteStore: noteStore)
        }
    }
    
    // MARK: - Helper Methods
    private func deleteNotes(offsets: IndexSet) {
        Task {
            for index in offsets {
                let note = noteStore.notes[index]
                try? await noteStore.deleteNote(note)
            }
        }
    }
}

// MARK: - Note Row View
struct NoteRowView: View {
    let note: Note
    @ObservedObject var noteStore: NoteStore
    
    var body: some View {
        HStack {
            Button(action: {
                Task {
                    try? await noteStore.toggleNoteCompletion(note)
                }
            }) {
                Image(systemName: note.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(note.isCompleted ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(note.title)
                    .font(.headline)
                    .strikethrough(note.isCompleted)
                
                Text(note.content)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(note.updatedAt, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Add Note View
struct AddNoteView: View {
    @ObservedObject var noteStore: NoteStore
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Content", text: $content, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveNote()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveNote() {
        let note = Note(title: title, content: content)
        Task {
            try? await noteStore.addNote(note)
            dismiss()
        }
    }
}

// MARK: - Note Detail View
struct NoteDetailView: View {
    let note: Note
    @ObservedObject var noteStore: NoteStore
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var content: String
    @State private var isEditing = false
    
    init(note: Note, noteStore: NoteStore) {
        self.note = note
        self.noteStore = noteStore
        self._title = State(initialValue: note.title)
        self._content = State(initialValue: note.content)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                if isEditing {
                    TextField("Title", text: $title)
                        .font(.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Content", text: $content, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(5...10)
                } else {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(content)
                        .font(.body)
                    
                    HStack {
                        Text("Created: \(note.createdAt, style: .date)")
                        Spacer()
                        Text("Updated: \(note.updatedAt, style: .relative)")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Note Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if isEditing {
                        Button("Save") {
                            saveChanges()
                        }
                    } else {
                        Button("Edit") {
                            isEditing = true
                        }
                    }
                }
                
                #if os(iOS)
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                #endif
            }
        }
    }
    
    private func saveChanges() {
        let updatedNote = Note(
            id: note.id,
            title: title,
            content: content,
            createdAt: note.createdAt,
            updatedAt: Date(),
            isCompleted: note.isCompleted
        )
        
        Task {
            try? await noteStore.updateNote(updatedNote)
            isEditing = false
        }
    }
}

#Preview {
    HomeView(noteStore: MockNoteStore(initialNotes: [
        Note(title: "Sample Note 1", content: "This is a sample note content"),
        Note(title: "Sample Note 2", content: "Another sample note", isCompleted: true)
    ]))
}
