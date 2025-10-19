//
//  NavigationViewFactory.swift
//  Core
//
//  Created by Federico Torres on 01/09/25.
//

import Foundation
import SwiftUI

public protocol NavigationViewFactory: Equatable, Sendable {
    func createView(for destination: NavigationDestination) -> AnyView
    func createView(for destination: NavigationDestination, onResult: @escaping (any NavigationResult) -> Void) -> AnyView
}

private struct NavigationViewFactoryKey: EnvironmentKey {
    static let defaultValue: (any NavigationViewFactory)? = nil
}

public extension EnvironmentValues {
    var navigationViewFactory: (any NavigationViewFactory)? {
        get { self[NavigationViewFactoryKey.self] }
        set { self[NavigationViewFactoryKey.self] = newValue }
    }
}
