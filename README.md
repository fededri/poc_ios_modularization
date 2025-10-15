# iOS Modularization POC - Modal Solution

> **Branch:** `modal_solution`  
> **Approach:** Decentralized navigation with modal presentations for cross-module flows

This branch demonstrates modular iOS architecture with complete module independence, using sheet modals for cross-module navigation.

## Overview

Decentralized solution where:
- Each module manages its own internal navigation
- Cross-module navigation uses sheet modals (`@Presents`)
- No central coordinator needed
- Modules are completely independent

## Key Features

- **Module Independence:** No module-to-module dependencies
- **Modal Navigation:** Cross-module flows shown as sheets
- **TCA @Presents:** Built-in TCA pattern for modal destinations
- **Simple:** No coordinator coupling or complex navigation logic
- **Scalable:** Easy to add new modules without coordination

## Architecture

### Module Structure

```
CoreInterfaces (SPM)  → Protocols & Models
Assets Module (SPM)   → Self-contained Asset Features
Issues Module (SPM)   → Self-contained Issue Features
App Target            → Composition Root + KMP Bridge
Shared (KMP)          → Business Logic
```

### Navigation Pattern

```swift
// In Asset Detail Feature
@Reducer
public struct AssetDetailFeature {
    @ObservableState
    public struct State {
        @Presents var destination: Destination.State?
    }
    
    public enum Action {
        case linkIssueTapped
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
        case issuesListPicker(IssuesListPickerFeature)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .linkIssueTapped:
                // Show modal
                state.destination = .issuesListPicker(
                    IssuesListPickerFeature.State()
                )
                return .none
                
            case .destination(.presented(.issuesListPicker(.issueSelected(let issue)))):
                // Handle result
                state.linkedIssue = issue
                state.destination = nil  // Dismiss modal
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
```

### View Layer

```swift
AssetDetailView(store: store)
    .sheet(item: $store.scope(state: \.destination?.issuesListPicker, 
                              action: \.destination.issuesListPicker)) { store in
        IssuesListPickerView(store: store)
    }
```

## Navigation Flow

```
Asset Detail → (Modal) Issues Picker → Select Issue → Dismiss → Asset Detail
```

**Key Point:** Cross-module navigation always presents modally, never pushes to a shared navigation stack.

## Pros

✅ **Complete Module Independence:** No dependencies between feature modules  
✅ **Easy to Scale:** Adding modules doesn't require coordinator changes  
✅ **Simple Architecture:** No complex navigation coordination  
✅ **TCA Native:** Uses built-in `@Presents` pattern  
✅ **Clear Boundaries:** Modal presentation makes transitions obvious  
✅ **Testable:** Each module tested in complete isolation  
✅ **Parallel Development:** Teams can work independently  

## Cons

❌ **Modal-Only Cross-Module:** Cannot push to shared navigation stack  
❌ **UX Limitation:** No drilldown navigation between modules  
❌ **Back Button:** Only works within modules, not across modals  
❌ **Navigation Stack:** Each module has separate stack  
❌ **Result Handling:** Callback pattern instead of async/await  
❌ **Modal Fatigue:** Many modals can feel disconnected  

## When to Use

**Best for:**
- Apps with independent feature areas
- Apps where modal navigation is acceptable UX
- Teams wanting maximum module decoupling
- Projects with many parallel development streams
- Apps with clear feature boundaries

**Not ideal for:**
- Apps requiring deep navigation hierarchies across modules
- Apps where modal presentations feel out of place
- Projects prioritizing seamless cross-module flows
- Apps with complex navigation state management

## Comparison with Other Branches

| Aspect | modal_solution | centralized_vanilla_swift | centralized_solution |
|--------|----------------|---------------------------|---------------------|
| **Cross-Module Nav** | Sheet modals | Push navigation | Push navigation |
| **Coordinator** | None | SwiftUI @Observable | TCA @Reducer |
| **Module Coupling** | None | Medium (bus) | High (knows all) |
| **Back Button** | Modal dismiss | Stack pop | Stack pop |
| **Result Handling** | Callbacks | Async/await | Action matching |
| **Scalability** | Excellent | Good | Moderate |
| **UX Flexibility** | Limited | High | High |

## Code Example

### Internal Navigation (Push)

```swift
// Within Assets module - uses path-based navigation
@Reducer
public struct AssetsListFeature {
    @ObservableState
    public struct State {
        @Presents var destination: Destination.State?
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
        case assetDetail(AssetDetailFeature)  // Internal push
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            case .assetTapped(let id):
                // Push within module
                state.destination = .assetDetail(
                    AssetDetailFeature.State(assetId: id)
                )
                return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
```

### Cross-Module Navigation (Modal)

```swift
// Asset Detail navigating to Issues (different module) - modal
@Reducer
public struct AssetDetailFeature {
    @ObservableState
    public struct State {
        @Presents var destination: Destination.State?
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
        case issuesListPicker(IssuesListPickerFeature)  // Cross-module modal
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            case .linkIssueTapped:
                // Show as sheet
                state.destination = .issuesListPicker(
                    IssuesListPickerFeature.State()
                )
                return .none
                
            case .destination(.presented(.issuesListPicker(.issueSelected(let issue)))):
                state.linkedIssue = issue
                state.destination = nil  // Dismiss
                return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
```

### View with Modal

```swift
struct AssetDetailView: View {
    let store: StoreOf<AssetDetailFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                // ... content ...
                Button("Link Issue") {
                    viewStore.send(.linkIssueTapped)
                }
            }
            .sheet(item: $store.scope(
                state: \.destination?.issuesListPicker,
                action: \.destination.issuesListPicker
            )) { store in
                NavigationStack {
                    IssuesListPickerView(store: store)
                }
            }
        }
    }
}
```

## Result Handling

Since cross-module navigation is modal, results flow back through the destination state:

```swift
case .destination(.presented(.issuesListPicker(.issueSelected(let issue)))):
    // Receive result from modal
    state.linkedIssue = issue
    state.destination = nil  // Dismiss modal
    return .none
```

No async/await or result bus needed - standard TCA pattern.

## Getting Started

1. **Clone and checkout this branch**
   ```bash
   git clone <repo-url>
   cd poc_ios_modularization
   git checkout modal_solution
   ```

2. **Open workspace**
   ```bash
   open modularizediOSApp/ModularizediOSApp.xcworkspace
   ```

3. **Run the app** to see modal-based navigation

4. **Notice:** Cross-module navigation presents as sheets, not pushes

## Key Differences from Other Approaches

### vs. centralized_vanilla_swift
- ❌ No continuation manager (no memory leak concerns)
- ❌ No result bus (uses standard TCA @Presents)
- ❌ No navigation controllers
- ✅ Simpler architecture
- ❌ Modal-only cross-module navigation

### vs. centralized_solution
- ❌ No central coordinator reducer
- ❌ No action bubbling to coordinator
- ✅ Complete module independence
- ❌ Cannot share navigation stack across modules

## Additional Resources

- [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [TCA @Presents Documentation](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/presents())
- [Main README](../../tree/main) - Compare all approaches

## License

MIT License
