//
//  NavigationViewFactory.swift
//  modularizediOSApp
//
//  Created by Federico Torres on 13/10/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import ComposableArchitecture
import CoreInterfaces
import Issues
import SwiftUI

class AppNavigationViewFactory: NavigationViewFactory, Equatable {
    func createView(for destination: NavigationDestination) -> AnyView {
        return createView(for: destination, onResult: { _ in })
    }
    
    func createView(for destination: NavigationDestination, onResult: @escaping (any NavigationResult) -> Void) -> AnyView {
        switch destination {
        case .issuesListPicker:
            let provider = IssuesListPickerProvider { issue in
                onResult(issue)
            }
            return AnyView(
                NavigationStack {
                    provider.make()
                }
            )
        case .assetsList, .issuesList: fatalError("not implemented")
        }
    }
    
    static func == (lhs: AppNavigationViewFactory, rhs: AppNavigationViewFactory) -> Bool {
        return lhs === rhs
    }
}
