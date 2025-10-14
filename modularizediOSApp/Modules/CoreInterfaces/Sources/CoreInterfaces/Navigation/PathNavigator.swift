//
//  Untitled.swift
//  CoreInterfaces
//
//  Created by Federico Torres on 13/10/25.
//
import Foundation
import SwiftUI

public struct PathNavigator: Navigator, Equatable, @unchecked Sendable {
    @Binding private var navigationPath: NavigationPath
    private let viewFactory: any NavigationViewFactory
    private let id = UUID()
    
    public init(navigationPath: Binding<NavigationPath>, viewFactory: any NavigationViewFactory) {
        self._navigationPath = navigationPath
        self.viewFactory = viewFactory
    }
    
    nonisolated public func navigate(to destination: NavigationDestination) {
        Task { @MainActor in
            navigationPath.append(destination)
        }
    }
    
    nonisolated public func navigate(to destination: NavigationDestination, style: NavigationPresentationStyle, onResult: @escaping (any NavigationResult) -> Void) {
        Task { @MainActor in
            navigationPath.append(destination)
        }
    }
    
    nonisolated public func navigate(to destination: NavigationDestination, style: NavigationPresentationStyle) {
        Task { @MainActor in
            navigationPath.append(destination)
        }
    }
    
    nonisolated public func dismiss(animated: Bool) {
        Task { @MainActor in
            if !navigationPath.isEmpty {
                navigationPath.removeLast()
            }
        }
    }
    
    nonisolated public func pop(animated: Bool) {
        Task { @MainActor in
            if !navigationPath.isEmpty {
                navigationPath.removeLast()
            }
        }
    }
    
    public static func == (lhs: PathNavigator, rhs: PathNavigator) -> Bool {
        return lhs.id == rhs.id
    }

    nonisolated public func navigate(to destination: NavigationDestination, onResult: @escaping (any NavigationResult) -> Void) {
        Task { @MainActor in
            navigationPath.append(destination)
        }
    }

    nonisolated public func viewForDestination(_ destination: NavigationDestination) -> AnyView {
        return viewFactory.createView(for: destination)
    }
    
    nonisolated public func viewForDestination(_ destination: NavigationDestination, onResult: @escaping (any NavigationResult) -> Void) -> AnyView {
        return viewFactory.createView(for: destination, onResult: onResult)
    }
}
