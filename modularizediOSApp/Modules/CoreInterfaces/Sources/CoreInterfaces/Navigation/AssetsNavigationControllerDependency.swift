//
//  AssetsNavigationControllerDependency.swift
//  CoreInterfaces
//
//  Created by Cursor on 15/10/25.
//

import ComposableArchitecture

/// Protocol for navigation controller that handles Assets module navigation.
/// The app target will provide a concrete implementation.
public protocol AssetsNavigationControllerProtocol: Sendable {
    /// Navigate to issue picker and await selected issue.
    /// Returns the selected issue or nil if cancelled.
    func navigateToIssuesPicker() async -> IssueUIModel?
}

/// TCA dependency registration for AssetsNavigationController.
/// This allows features to access the navigation controller via @Dependency.
extension DependencyValues {
    public var assetsNavigationController: any AssetsNavigationControllerProtocol {
        get { self[AssetsNavigationControllerKey.self] }
        set { self[AssetsNavigationControllerKey.self] = newValue }
    }
}

private enum AssetsNavigationControllerKey: DependencyKey {
    public static let liveValue: any AssetsNavigationControllerProtocol = UnimplementedNavigationController()
}

/// Placeholder implementation that crashes if used without proper injection.
/// This ensures developers must inject the real implementation in ContentView.
private struct UnimplementedNavigationController: AssetsNavigationControllerProtocol {
    func navigateToIssuesPicker() async -> IssueUIModel? {
        fatalError("AssetsNavigationController must be injected via withDependencies in ContentView")
    }
}

