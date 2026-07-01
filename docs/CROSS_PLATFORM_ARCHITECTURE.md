# Cross-Platform Architecture (macOS-first)

This document describes the cross-platform architecture for the HopList app, currently macOS-first with shared architecture ready for iOS expansion.

## Overview

The app follows a **Shared-first** architecture where business logic is shared between platforms, while platform-specific code is isolated in dedicated directories. Currently macOS-first, with the shared architecture in place for future iOS expansion.

## Directory Structure

```
HopList/
├── Shared/                   # Cross-platform shared logic (ready for iOS)
│   ├── Models/              # Data models (SwiftData)
│   ├── Services/            # Business logic services
│   └── ViewModels/          # Shared view models
├── macOS/                   # macOS-specific code
│   ├── App/                 # macOS app entry point
│   ├── Resources/           # macOS resources
│   └── Features/            # macOS-specific features
├── App/                     # Shared UI components
│   ├── Views/               # Cross-platform views
│   └── Components/          # Reusable components
├── HopList/                 # Current implementation
│   ├── ContentView.swift    # Main UI
│   ├── Item.swift          # Data model
│   ├── HopListApp.swift    # App entry point
│   └── Agents/             # Background agents
├── Tests/                   # Unit tests
├── UITests/                 # UI tests
├── HopListTests/            # Legacy unit tests
└── HopListUITests/          # Legacy UI tests
```

## Architecture Principles

### 1. Shared Business Logic
- All business logic is in the `Shared/` directory
- Platform-agnostic code that works on both iOS and macOS
- Uses protocols for dependency injection and testability

### 2. Platform-Specific UI
- UI components adapt to platform conventions
- macOS: NavigationSplitView, sidebar, window management
- iOS: TabView, NavigationView, sheets (future expansion)

### 3. Dependency Injection
- Services are injected through protocols
- Easy to mock for testing
- Clear separation of concerns

## Key Components

### Shared Models
```swift
@Model
public class Note {
    public var id: UUID
    public var title: String
    public var content: String
    public var createdAt: Date
    public var updatedAt: Date
    public var isCompleted: Bool
}
```

### Shared Services
```swift
public protocol NoteStore: ObservableObject {
    var notes: [Note] { get }
    func addNote(_ note: Note) async throws
    func updateNote(_ note: Note) async throws
    func deleteNote(_ note: Note) async throws
}
```

### Cross-Platform Views
```swift
public struct HomeView: View {
    public var body: some View {
        #if os(iOS)
        iOSHomeView()
        #elseif os(macOS)
        macOSHomeView()
        #endif
    }
}
```

## Platform-Specific Considerations

### macOS (Current)
- Uses `NavigationSplitView` for sidebar navigation
- Window-based interface
- Menu bar integration
- Keyboard shortcuts
- AppKit/SwiftUI integration

### iOS (Future Expansion)
- Uses `NavigationView` and `TabView`
- Modal presentations with sheets
- Touch-based interactions
- Status bar and safe area handling

## Testing Strategy

### Unit Tests
- Test shared business logic in `Tests/`
- Use mock implementations for services
- Test platform-agnostic code

### UI Tests
- Test critical user flows on macOS
- Platform-specific UI test scenarios
- Accessibility testing
- Future iOS test scenarios when platform is added

## Development Workflow

### Using Cursor Agents
1. **@logic-agent**: Work on shared business logic (ready for iOS expansion)
2. **@ui-agent**: Create macOS UI components with AppKit/SwiftUI integration
3. **@platform-agent**: Handle macOS-specific code (menu bar, window management)
4. **@test-agent**: Write tests for new features

### Example Commands
```bash
# Create shared model
@logic-agent create a Task model in Shared/Models with priority and due date

# Create macOS view
@ui-agent create a TaskListView with NavigationSplitView for macOS

# Add macOS-specific feature
@platform-agent add menu bar integration and keyboard shortcuts
```

## Migration from Current Structure

The current `HopList/` directory contains the existing iOS implementation. To migrate to the new architecture:

1. **Move models**: `HopList/Item.swift` → `Shared/Models/`
2. **Extract services**: Create service protocols in `Shared/Services/`
3. **Create cross-platform views**: Move UI to `App/Views/`
4. **Add macOS target**: Create macOS-specific entry points

## Best Practices

1. **Keep shared code platform-agnostic**
2. **Use conditional compilation sparingly**
3. **Test on both platforms regularly**
4. **Follow platform design guidelines**
5. **Document platform-specific decisions**

## Future Enhancements

- Add watchOS support
- Implement iCloud sync
- Add widget support
- Create Catalyst version
