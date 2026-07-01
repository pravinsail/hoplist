# Task Templates for Cursor Agents

## Quick Reference

### UI Development Tasks
```
@ui-agent: Create a [component name] view that [functionality]
Requirements:
- [specific requirement 1]
- [specific requirement 2]
- [specific requirement 3]
Design: [design pattern/style]
Accessibility: [accessibility requirements]
```

### Logic Implementation Tasks
```
@logic-agent: Implement [feature name] in [file/component]
Functionality:
- [core functionality 1]
- [core functionality 2]
- [core functionality 3]
Error handling: [error scenarios]
Performance: [performance requirements]
```

### Testing Tasks
```
@test-agent: Write [test type] for [component/feature]
Coverage:
- [test scenario 1]
- [test scenario 2]
- [test scenario 3]
Edge cases: [edge cases to test]
Mocking: [mocking requirements]
```

## Common Task Examples

### 1. Create a New SwiftUI View
```
@ui-agent: Create a HopDetailView that displays hop information
Requirements:
- Show hop name, description, and rating
- Include an image placeholder
- Add a favorite button
- Support dark mode
Design: Card-based layout with rounded corners
Accessibility: Proper labels and VoiceOver support
```

### 2. Add a New Background Agent
```
@logic-agent: Create a HopValidationAgent for data validation
Functionality:
- Validate hop data before saving
- Check for duplicate entries
- Ensure required fields are present
- Log validation errors
Error handling: Graceful error recovery
Performance: Fast validation (< 100ms)
```

### 3. Write Unit Tests
```
@test-agent: Write unit tests for HopListSyncAgent
Coverage:
- Test successful sync operations
- Test network failure scenarios
- Test data corruption handling
- Test retry mechanisms
Edge cases: Empty data, malformed responses
Mocking: Mock network requests and SwiftData context
```

### 4. Update Documentation
```
@docs-agent: Update README with new hop validation feature
Content:
- Add feature description
- Include usage examples
- Document configuration options
- Update setup instructions
Examples: Code snippets showing usage
Accuracy: Test all examples before committing
```

### 5. Configure Build Settings
```
@build-agent: Configure Xcode project for background processing
Settings:
- Add background modes capability
- Configure background task identifiers
- Set up proper entitlements
- Optimize build performance
Deployment: Ensure App Store compliance
```

## Multi-Agent Task Workflows

### Complete Feature Development
```
Phase 1 - Logic:
@logic-agent: Create HopCategory data model and validation logic

Phase 2 - UI:
@ui-agent: Create HopCategoryListView and HopCategoryDetailView

Phase 3 - Testing:
@test-agent: Write comprehensive tests for HopCategory feature

Phase 4 - Documentation:
@docs-agent: Document HopCategory feature and API

Phase 5 - Build:
@build-agent: Ensure proper project configuration
```

### Bug Fix Workflow
```
Phase 1 - Investigation:
@test-agent: Create failing test that reproduces the bug

Phase 2 - Fix:
@logic-agent: Fix the bug in the core logic

Phase 3 - UI Update:
@ui-agent: Update UI if the bug affects user interface

Phase 4 - Verification:
@test-agent: Verify the fix with updated tests

Phase 5 - Documentation:
@docs-agent: Update documentation if API changed
```

## Task Maintenance Patterns

### Daily Development
```
Morning:
@docs-agent: Review and update task list
@test-agent: Run test suite and fix any failures

Development:
@ui-agent: Work on UI components
@logic-agent: Implement business logic
@platform-agent: Handle platform-specific issues

Evening:
@test-agent: Write tests for new features
@docs-agent: Update documentation
@build-agent: Ensure clean builds
```

### Feature Completion Checklist
```
✅ @logic-agent: Core functionality implemented
✅ @ui-agent: User interface completed
✅ @test-agent: Tests written and passing
✅ @docs-agent: Documentation updated
✅ @build-agent: Build configuration verified
✅ @platform-agent: Platform integration tested
```

## Agent Communication Patterns

### Handoff Between Agents
```
@logic-agent: I've created the HopCategory model. 
@ui-agent: Please create a view to display hop categories using this model.

@ui-agent: I've created the HopCategoryView. 
@test-agent: Please write tests for both the model and view.

@test-agent: Tests are complete and passing. 
@docs-agent: Please document the new HopCategory feature.
```

### Collaborative Tasks
```
@ui-agent + @logic-agent: Work together to create a hop search feature
- @logic-agent: Implement search algorithm and data filtering
- @ui-agent: Create search UI with real-time results
- Both: Ensure proper data binding and state management
```

## Task Priority Levels

### High Priority (Critical)
```
@platform-agent: Fix app crash on background task execution
@logic-agent: Resolve data corruption issue in sync agent
@test-agent: Fix failing tests blocking deployment
```

### Medium Priority (Important)
```
@ui-agent: Improve accessibility of existing views
@logic-agent: Optimize background agent performance
@docs-agent: Update user documentation
```

### Low Priority (Nice to Have)
```
@ui-agent: Add subtle animations to improve UX
@logic-agent: Add additional logging for debugging
@docs-agent: Create developer tutorials
```

## Quality Assurance Tasks

### Code Review
```
@logic-agent: Review business logic for edge cases
@ui-agent: Review UI for accessibility and usability
@test-agent: Review test coverage and quality
@docs-agent: Review documentation accuracy
```

### Performance Optimization
```
@logic-agent: Profile and optimize data operations
@ui-agent: Optimize view rendering and animations
@platform-agent: Optimize background task scheduling
@build-agent: Optimize build and deployment process
```

### Security Review
```
@logic-agent: Review data handling for security issues
@platform-agent: Review permissions and entitlements
@test-agent: Add security-focused tests
@docs-agent: Document security considerations
```

## Emergency Tasks

### Critical Bug Fix
```
@test-agent: Create minimal test case reproducing the issue
@logic-agent: Implement immediate fix with minimal changes
@ui-agent: Update UI if user-facing issue
@docs-agent: Document the fix and any workarounds
```

### Hotfix Deployment
```
@build-agent: Prepare hotfix build configuration
@test-agent: Verify fix with targeted tests
@docs-agent: Update release notes
@platform-agent: Ensure deployment compatibility
```

This template system ensures consistent, high-quality task execution across all aspects of your HopList project development.
