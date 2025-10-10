//
//  File.swift
//  Core
//
//  Created by Federico Torres on 31/08/25.
//

import Foundation
import SwiftUI

public protocol Navigator: Equatable, Sendable {
    func navigate(to destination: NavigationDestination)

    func navigate(to destination: NavigationDestination, style: NavigationPresentationStyle)
    
    func navigate(to destination: NavigationDestination, onResult: @escaping (any NavigationResult) -> Void)
    
    func navigate(to destination: NavigationDestination, style: NavigationPresentationStyle, onResult: @escaping (any NavigationResult) -> Void)

    func dismiss(animated: Bool)

    func pop(animated: Bool)

    func viewForDestination(_ destination: NavigationDestination) -> AnyView
    
    func viewForDestination(_ destination: NavigationDestination, onResult: @escaping (any NavigationResult) -> Void) -> AnyView
}

private struct NavigatorKey: EnvironmentKey {
    static let defaultValue: any Navigator = FakeNavigator()
}

public extension EnvironmentValues {
    var navigator: any Navigator {
        get { self[NavigatorKey.self] }
        set { self[NavigatorKey.self] = newValue }
    }
}

/// Dummy implementation for SwiftUI Previews
public struct FakeNavigator: Navigator {
    public init() {}
    
    var id: String {
        "FakeNavigator"
    }
    
    public func navigate(to destination: CoreInterfaces.NavigationDestination) {

    }

    public func navigate(to destination: CoreInterfaces.NavigationDestination, style: CoreInterfaces.NavigationPresentationStyle, onResult: @escaping (any NavigationResult) -> Void) {

    }

    public func navigate(to destination: CoreInterfaces.NavigationDestination, style: CoreInterfaces.NavigationPresentationStyle) {

    }

    public func dismiss(animated: Bool) {

    }

    public func pop(animated: Bool) {

    }

    public func navigate(to destination: CoreInterfaces.NavigationDestination, onResult: @escaping (any NavigationResult) -> Void) {

    }

    public func viewForDestination(_ destination: CoreInterfaces.NavigationDestination) -> AnyView {
        return AnyView(Text("Fake View"))
    }
    
    public func viewForDestination(_ destination: CoreInterfaces.NavigationDestination, onResult: @escaping (any NavigationResult) -> Void) -> AnyView {
        return AnyView(Text("Fake View"))
    }
}
