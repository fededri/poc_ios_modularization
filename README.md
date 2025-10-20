# iOS Modularization POC with Kotlin Multiplatform

This repository explores different architectural approaches for modularizing an iOS application that uses Kotlin Multiplatform (KMP) for shared business logic.

## Common Architecture Elements

All branches share these core principles:

### Module Structure
```
CoreInterfaces (SPM)  → Protocols & Models
Assets Module (SPM)   → Asset Features
Issues Module (SPM)   → Issue Features
App Target            → Composition & KMP Bridge
Shared (KMP)          → Business Logic
```

### Critical Constraint
**Only the App target can depend on KMP.** SPM modules use protocol abstractions; the App target provides KMP implementations via TCA's `@Dependency` system.

### Dependency Injection
1. Modules define repository protocols
2. App target implements using KMP
3. TCA's `@Dependency` injects implementations
4. Mock implementations for previews/tests

## Branch Overview

### 🎯 [centralized_vanilla_swift](../../tree/centralized_vanilla_swift) (Recommended)

**Approach:** Vanilla SwiftUI with path-based navigation and lifecycle-aware continuations.

**Key Features:**
- `@Observable` App Coordinator with NavigationPath
- Async/await navigation for result-returning screens
- Type-erased `NavigationContinuationManager` prevents memory leaks
- Navigation Result Bus eliminates circular dependencies
- O(1) performance regardless of number of navigation types

**Pros:**
- No continuation leaks (lifecycle-aware)
- Highly scalable (single manager handles all nav types)
- Standard Apple frameworks (no third-party nav libs)
- Clean async/await API

**Cons:**
- Cannot observe NavigationPath changes directly (SwiftUI limitation)
- Initial setup complexity
- Continuation management requires understanding

**Best for:** Production apps requiring robust navigation with multiple result-returning screens.

---

### 📦 [centralized_solution](../../tree/centralized_solution)

**Approach:** TCA Reducer-based App Coordinator that listens to child actions.

**Key Features:**
- `@Reducer` struct AppCoordinator with StackState
- TCA's ifCaseLet for path navigation
- Coordinator listens to all child feature actions
- Full TCA integration (actions, state, reducers)

**Pros:**
- Pure TCA solution (no Combine bridge needed)
- Time-travel debugging works
- Testable with TestStore
- All navigation logic in reducers

**Cons:**
- Coordinator tightly coupled to all features
- Every navigation action bubbles up to coordinator
- Requires TCA boilerplate for navigation
- Harder to add new modules (coordinator must know about them)

**Best for:** Smaller apps or teams already deeply invested in TCA patterns.

---

### 📱 [modal_solution](../../tree/modal_solution)

**Approach:** Decentralized navigation using sheet modals for cross-module navigation.

**Key Features:**
- Each module manages its own internal navigation
- Cross-module navigation via sheets/modals
- TCA's `@Presents` for modal destinations
- No central coordinator needed

**Pros:**
- Modules are completely independent
- No coordinator coupling
- Simple to understand
- Easy to add new modules

**Cons:**
- Cross-module navigation always shows as modal (UX limitation)
- No drilldown navigation between modules
- Cannot maintain navigation stack across modules
- Back button behavior limited to modal dismissal

**Best for:** Apps with mostly independent feature areas or where modal navigation is acceptable.

---

## Architecture Comparison

| Aspect | centralized_vanilla_swift | centralized_solution | modal_solution |
|--------|--------------------------|---------------------|----------------|
| **Navigation Type** | Path-based (NavigationStack) | Path-based (StackState) | Modal-based (@Presents) |
| **Coordinator** | Vanilla SwiftUI @Observable | TCA @Reducer | None |
| **Cross-module Nav** | Push navigation | Push navigation | Sheet modals |
| **Back Button** | Native stack pop | Native stack pop | Modal dismiss |
| **Continuation Leaks** | Prevented ✅ | N/A | N/A |
| **Result Handling** | Async/await + Result Bus | TCA actions | Callback closures |
| **Scalability** | O(1) per nav type | O(n) with features | Excellent |
| **Coupling** | Medium (bus + controllers) | High (knows all features) | Low |
| **Testability** | Good (mock controllers) | Excellent (TestStore) | Good (mock repos) |

