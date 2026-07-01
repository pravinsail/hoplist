# Background Agents Guide

This document provides detailed information about implementing and using background agents in the HopList application.

## Overview

Background agents in HopList are designed to perform automated tasks when the app is not actively being used. They can sync data, perform maintenance tasks, and handle other background operations.

## Architecture

### Core Components

1. **BackgroundAgent Protocol**: Defines the interface for all background agents
2. **BaseBackgroundAgent**: Provides base implementation with common functionality
3. **AgentManager**: Coordinates and manages all background agents
4. **Specific Agents**: Implementations for specific tasks (e.g., HopListSyncAgent)

### File Structure

```
HopList/Agents/
├── BackgroundAgent.swift      # Protocol and base implementation
├── AgentManager.swift         # Agent coordination
└── HopListSyncAgent.swift     # Example sync agent
```

## Creating a New Background Agent

### Step 1: Create the Agent Class

```swift
import Foundation
import SwiftData

class MyCustomAgent: BaseBackgroundAgent {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        super.init(taskIdentifier: "com.hoplist.custom")
    }
    
    override func performBackgroundTask() async {
        print("MyCustomAgent: Starting background task...")
        
        // Your background task implementation here
        
        // Schedule next execution
        scheduleBackgroundTask()
        
        print("MyCustomAgent: Background task completed")
    }
}
```

### Step 2: Register the Agent

Add your agent to the `AgentManager.setupAgents()` method:

```swift
private func setupAgents() {
    guard let modelContext = modelContext else { return }
    
    // Existing agents
    let syncAgent = HopListSyncAgent(modelContext: modelContext)
    agents.append(syncAgent)
    
    // Add your new agent
    let customAgent = MyCustomAgent(modelContext: modelContext)
    agents.append(customAgent)
}
```

## Background Task Types

### App Refresh Tasks
- Used for updating app content
- Limited execution time (30 seconds)
- Good for data synchronization

### Processing Tasks
- Used for longer-running operations
- More execution time available
- Good for data processing and analysis

## Best Practices

### 1. Task Duration
- Keep tasks short and efficient
- Respect system limitations
- Handle task expiration gracefully

### 2. Error Handling
- Always implement proper error handling
- Log errors for debugging
- Don't crash the background task

### 3. Resource Management
- Be mindful of battery usage
- Minimize network requests
- Use efficient data structures

### 4. Scheduling
- Don't schedule tasks too frequently
- Use appropriate intervals
- Consider user behavior patterns

## Configuration

### Info.plist Requirements

Add the following to your Info.plist:

```xml
<key>BGTaskSchedulerPermittedIdentifiers</key>
<array>
    <string>com.hoplist.sync</string>
    <string>com.hoplist.custom</string>
</array>
```

### Background Modes

Add background modes to Info.plist:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>background-processing</string>
    <string>background-fetch</string>
</array>
```

## Testing Background Agents

### Simulator Testing
1. Run the app in simulator
2. Background the app (⌘+Shift+H)
3. Wait for background task execution
4. Check console logs for agent activity

### Device Testing
1. Install on physical device
2. Background the app
3. Monitor battery usage
4. Check background app refresh settings

## Debugging

### Console Logs
Background agents log their activity to the console. Look for:
- Agent initialization messages
- Task execution logs
- Error messages
- Scheduling confirmations

### Common Issues

1. **Tasks not executing**: Check background app refresh settings
2. **Tasks expiring**: Optimize task duration
3. **Permission denied**: Verify Info.plist configuration
4. **Battery drain**: Review task frequency and efficiency

## Monitoring and Analytics

### Task Success Rate
Track how often background tasks complete successfully:

```swift
func performBackgroundTask() async {
    let startTime = Date()
    
    do {
        // Task implementation
        await recordSuccess(duration: Date().timeIntervalSince(startTime))
    } catch {
        await recordFailure(error: error)
    }
}
```

### Performance Metrics
Monitor:
- Task execution time
- Memory usage
- Battery impact
- Network usage

## Security Considerations

1. **Data Protection**: Ensure sensitive data is properly encrypted
2. **Network Security**: Use secure connections for data sync
3. **Access Control**: Validate permissions before performing tasks
4. **Error Handling**: Don't expose sensitive information in error logs

## Future Enhancements

### Planned Features
- Agent priority levels
- Conditional task execution
- Advanced scheduling options
- Performance optimization
- Analytics dashboard

### Integration Opportunities
- Push notifications
- CloudKit sync
- Third-party APIs
- Machine learning models
