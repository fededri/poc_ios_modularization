# iOS Modularization POC - Centralized TCA Solution

> **Branch:** `centralized_solution`  
> **Approach:** TCA Reducer-based App Coordinator that listens to child feature actions

This branch demonstrates modular iOS architecture using a centralized TCA Reducer as the coordinator for cross-module navigation.

## Overview

Pure TCA solution where the App Coordinator is a `@Reducer` that:
- Maintains a `StackState<Path.State>` for navigation
- Listens to all child feature actions
- Performs navigation in response to actions
- Uses TCA's `.ifCaseLet` for path-based navigation

## Key Features

- **Pure TCA:** No Combine bridges, no vanilla SwiftUI coordinators
- **Centralized Logic:** All navigation decisions in AppCoordinator reducer
- **Type-Safe Navigation:** Compiler-enforced navigation paths
- **Testable:** Full TestStore support for navigation flows
- **Time-Travel Debugging:** Works with TCA's debugging tools

## Architecture

### Module Structure

```
CoreInterfaces (SPM)  → Protocols & Models
Assets Module (SPM)   → Asset Features  
Issues Module (SPM)   → Issue Features
App Target            → AppCoordinator Reducer + KMP Bridge
Shared (KMP)          → Business Logic
```

### Coordinator Pattern

```swift
@Reducer
struct AppCoordinator {
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var assetsList = AssetsListFeature.State()
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case assetsList(AssetsListFeature.Action)
    }
    
    @Reducer
    enum Path {
        case assetDetail(AssetDetailFeature)
        case issuesListPicker(IssuesListPickerFeature)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // Coordinator listens to child actions
            case .assetsList(.assetTapped(let id)):
                state.path.append(.assetDetail(
                    AssetDetailFeature.State(assetId: id)
                ))
                return .none
                
            case .assetsList(.destination(.presented(.assetDetail(.linkIssueTapped)))):
                state.path.append(.issuesListPicker(
                    IssuesListPickerFeature.State()
                ))
                return .none
                
            case .path(.element(id: _, action: .issuesListPicker(.issueSelected(let issue)))):
                // Handle result and pop
                if let assetDetailId = state.path.ids.dropLast().last,
                   case .assetDetail = state.path[id: assetDetailId] {
                    // Update asset detail with selected issue
                }
                state.path.removeLast()
                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        
        Scope(state: \.assetsList, action: \.assetsList) {
            AssetsListFeature()
        }
    }
}
```

### Navigation Flow

```
User Action → Feature sends action → Coordinator observes action → 
Coordinator mutates path → SwiftUI updates navigation stack
```

## Pros

✅ **Pure TCA Solution:** No external navigation patterns  
✅ **Time-Travel Debugging:** Full TCA debugger support  
✅ **Testable:** Complete navigation flow testing with TestStore  
✅ **Type-Safe:** Compiler enforces valid navigation paths  
✅ **Consistent:** All navigation logic in one place (coordinator reducer)  
✅ **Predictable:** State changes drive navigation (unidirectional flow)

## Cons

❌ **Tight Coupling:** Coordinator must know about all features  
❌ **Action Bubbling:** Every navigation action bubbles to coordinator  
❌ **Boilerplate:** Requires reducer composition for each feature  
❌ **Scalability:** Adding features requires coordinator changes  
❌ **Result Handling:** Complex pattern matching for navigation results  
❌ **Path Manipulation:** Must manually track path IDs for result delivery

## When to Use

**Best for:**
- Smaller apps with manageable number of features
- Teams deeply invested in TCA patterns
- Apps requiring time-travel debugging
- Projects prioritizing testability over decoupling

**Not ideal for:**
- Large apps with many features (coordinator grows too large)
- Teams wanting loose coupling between modules
- Apps requiring frequent module additions
- Projects prioritizing module independence

## Comparison with Other Branches

| Aspect | centralized_solution | centralized_vanilla_swift | modal_solution |
|--------|---------------------|---------------------------|----------------|
| **Coordinator** | TCA @Reducer | SwiftUI @Observable | None |
| **Navigation** | StackState | NavigationPath | @Presents |
| **Result Handling** | Action matching | Async/await | Callbacks |
| **Coupling** | High | Medium | Low |
| **TCA Integration** | Full | Partial (features only) | Partial |
| **Testability** | Excellent | Good | Good |

## Code Example

### Feature Sends Navigation Action

```swift
@Reducer
public struct AssetsListFeature {
    public enum Action {
        case assetTapped(id: String)
        // ...
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .assetTapped(let id):
                // Action bubbles up to coordinator
                return .none
            // ...
            }
        }
    }
}
```

### Coordinator Handles Navigation

```swift
@Reducer
struct AppCoordinator {
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .assetsList(.assetTapped(let id)):
                // Coordinator performs navigation
                state.path.append(.assetDetail(
                    AssetDetailFeature.State(assetId: id)
                ))
                return .none
            // ...
            }
        }
        // ...
    }
}
```

### Testing Navigation

```swift
@Test
func testAssetNavigation() async {
    let store = TestStore(initialState: AppCoordinator.State()) {
        AppCoordinator()
    }
    
    await store.send(.assetsList(.assetTapped(id: "123"))) {
        $0.path.append(.assetDetail(
            AssetDetailFeature.State(assetId: "123")
        ))
    }
}
```

## Getting Started

1. **Clone and checkout this branch**
   ```bash
   git clone <repo-url>
   cd poc_ios_modularization
   git checkout centralized_solution
   ```

2. **Open workspace**
   ```bash
   open modularizediOSApp/ModularizediOSApp.xcworkspace
   ```

3. **Run the app** to see TCA-based navigation in action

4. **Explore AppCoordinator** in `modularizediOSApp/AppCoordinator.swift`

## Additional Resources

- [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [TCA Navigation](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/navigation)
- [Main README](../../tree/main) - Compare all approaches

## License

MIT License
