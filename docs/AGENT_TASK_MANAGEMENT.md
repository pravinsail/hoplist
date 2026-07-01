# Cursor Agent Task Management Guide

## Overview

This guide explains how to effectively assign, track, and maintain tasks using Cursor AI agents in the HopList project.

## Agent Locations and Scopes

### 1. UI Agent (@ui-agent)
**Scope:** `HopList/**/*.swift`
**Location:** UI-related files like `ContentView.swift`

**Tasks:**
- Create and modify SwiftUI views
- Implement responsive layouts
- Add animations and transitions
- Ensure accessibility compliance
- Optimize UI performance

**Example Tasks:**
```
@ui-agent: Create a hop list item detail view with smooth animations
@ui-agent: Add dark mode support to all views
@ui-agent: Implement a search bar with real-time filtering
```

### 2. Logic Agent (@logic-agent)
**Scope:** `HopList/Agents/**/*.swift`, `HopList/Item.swift`
**Location:** Background agents and data models

**Tasks:**
- Implement background agents
- Create data models
- Handle business logic
- Manage data persistence
- Implement algorithms

**Example Tasks:**
```
@logic-agent: Create a new background agent for data validation
@logic-agent: Add a new data model for hop categories
@logic-agent: Implement data synchronization logic
@logic-agent: Add error handling to existing agents
```

### 3. Platform Agent (@platform-agent)
**Scope:** `HopList/HopListApp.swift`, `HopList.xcodeproj/**/*`
**Location:** App configuration and platform integration

**Tasks:**
- Configure app lifecycle
- Set up background tasks
- Manage permissions
- Configure Xcode settings
- Handle platform-specific features

**Example Tasks:**
```
@platform-agent: Add background task permissions to Info.plist
@platform-agent: Configure app for background processing
@platform-agent: Set up proper app lifecycle management
@platform-agent: Add required iOS capabilities
```

### 4. Test Agent (@test-agent)
**Scope:** `HopListTests/**/*.swift`, `HopListUITests/**/*.swift`
**Location:** Test files

**Tasks:**
- Write unit tests
- Create UI tests
- Ensure test coverage
- Debug test failures
- Maintain test quality

**Example Tasks:**
```
@test-agent: Write unit tests for HopListSyncAgent
@test-agent: Create UI tests for hop list navigation
@test-agent: Add test coverage for background agents
@test-agent: Fix failing tests in the test suite
```

### 5. Docs Agent (@docs-agent)
**Scope:** `README.md`, `docs/**/*.md`
**Location:** Documentation files

**Tasks:**
- Update README files
- Create technical documentation
- Maintain user guides
- Generate changelogs
- Ensure documentation accuracy

**Example Tasks:**
```
@docs-agent: Update README with new background agent features
@docs-agent: Create a user guide for the hop list app
@docs-agent: Document the API for background agents
@docs-agent: Generate release notes for the latest version
```

### 6. Build Agent (@build-agent)
**Scope:** `HopList.xcodeproj/**/*`, `.gitignore`
**Location:** Build configuration files

**Tasks:**
- Configure Xcode project
- Set up CI/CD pipelines
- Manage dependencies
- Optimize build settings
- Handle deployment

**Example Tasks:**
```
@build-agent: Configure Xcode project for background processing
@build-agent: Set up GitHub Actions for automated testing
@build-agent: Optimize build settings for performance
@build-agent: Add proper code signing configuration
```

## Task Assignment Workflow

### Step 1: Identify the Task Type
Determine which agent is best suited for your task:
- UI changes → @ui-agent
- Business logic → @logic-agent
- Platform integration → @platform-agent
- Testing → @test-agent
- Documentation → @docs-agent
- Build configuration → @build-agent

### Step 2: Use Proper Agent Syntax
```
@agent-name: Specific task description with clear requirements
```

### Step 3: Provide Context
Give the agent enough context to understand the task:
```
@ui-agent: Create a new SwiftUI view for displaying hop details. 
The view should show hop name, description, and rating. 
Use a card-based design with rounded corners and shadows.
```

### Step 4: Review and Iterate
- Review the agent's output
- Provide feedback if needed
- Ask for modifications or improvements

## Task Maintenance Best Practices

### 1. Clear Task Descriptions
- Be specific about requirements
- Include acceptance criteria
- Mention any constraints or dependencies

### 2. Context Provision
- Provide relevant code context
- Mention related files or components
- Include any existing patterns to follow

### 3. Iterative Refinement
- Start with high-level requirements
- Refine based on agent output
- Ask for specific improvements

### 4. Quality Assurance
- Review agent-generated code
- Test functionality
- Ensure it follows project standards

## Common Task Patterns

### UI Development
```
@ui-agent: Create a [component name] that [functionality]. 
Use [design pattern] and ensure [requirements].
```

### Logic Implementation
```
@logic-agent: Implement [feature] in [file/component]. 
Handle [edge cases] and ensure [performance requirements].
```

### Testing
```
@test-agent: Write [test type] for [component/feature]. 
Cover [scenarios] and ensure [coverage requirements].
```

### Documentation
```
@docs-agent: Update [document] with [information]. 
Include [examples] and ensure [accuracy requirements].
```

## Agent Collaboration

### Multi-Agent Tasks
For complex tasks that require multiple agents:

1. **Start with the primary agent:**
```
@logic-agent: Create a new data model for hop categories
```

2. **Follow up with related agents:**
```
@ui-agent: Create a view to display the new hop categories
@test-agent: Write tests for the new hop categories model
@docs-agent: Document the new hop categories feature
```

### Agent Handoffs
When one agent completes a task, you can hand off to another:
```
@logic-agent: I've created the data model. Now @ui-agent, create a view to display it.
```

## Troubleshooting

### Agent Not Responding
- Check if the file is in the agent's scope
- Verify the agent syntax (@agent-name:)
- Ensure the task is within the agent's capabilities

### Incorrect Agent Selection
- Review the agent scopes in `.cursorrules`
- Choose the most appropriate agent for your task
- Consider using multiple agents for complex tasks

### Quality Issues
- Provide more specific requirements
- Include examples or references
- Ask for specific improvements or modifications

## Task Tracking

### Recommended Tools
- GitHub Issues for task tracking
- Project boards for workflow management
- Commit messages for task completion

### Task Documentation
- Document completed tasks in commit messages
- Update relevant documentation
- Track agent performance and effectiveness

## Example Task Workflow

### Complete Feature Development
1. **Planning:** Define requirements and acceptance criteria
2. **Logic:** @logic-agent implements core functionality
3. **UI:** @ui-agent creates user interface
4. **Testing:** @test-agent writes comprehensive tests
5. **Documentation:** @docs-agent updates documentation
6. **Build:** @build-agent ensures proper configuration
7. **Review:** Test and validate the complete feature

This workflow ensures comprehensive coverage and maintains code quality across all aspects of the project.
