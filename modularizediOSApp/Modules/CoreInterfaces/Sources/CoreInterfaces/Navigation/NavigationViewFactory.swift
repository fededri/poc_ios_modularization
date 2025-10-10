//
//  NavigationViewFactory.swift
//  Core
//
//  Created by Federico Torres on 01/09/25.
//

import Foundation
import SwiftUI

public protocol NavigationViewFactory: Equatable {
    func createView(for destination: NavigationDestination) -> AnyView
    func createView(for destination: NavigationDestination, onResult: @escaping (any NavigationResult) -> Void) -> AnyView
}