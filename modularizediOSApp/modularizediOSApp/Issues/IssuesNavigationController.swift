//
//  IssuesNavigationController.swift
//  modularizediOSApp
//
//  Created by Cursor on 15/10/25.
//

import Combine
import CoreInterfaces
import SwiftUI

/// Navigation controller for the Issues module.
/// Publishes navigation actions for other controllers to listen to.
final class IssuesNavigationController {
    private let path: Binding<NavigationPath>
    private let navigation: IssuesNavigation
    private var cancellables = Set<AnyCancellable>()
    
    init(path: Binding<NavigationPath>, navigation: IssuesNavigation) {
        self.path = path
        self.navigation = navigation
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        navigation.publisher
            .sink { [weak self] action in
                self?.handle(action)
            }
            .store(in: &cancellables)
    }
    
    private func handle(_ action: IssuesNavigation.Action) {
        switch action {
        case .issueSelected, .cancelTapped:
            // Results are handled by calling controllers (e.g., AssetsNavigationController)
            // This controller just publishes the action for others to listen to
            break
        }
    }
}

