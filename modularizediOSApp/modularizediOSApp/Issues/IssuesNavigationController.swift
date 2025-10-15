//
//  IssuesNavigationController.swift
//  modularizediOSApp
//
//  Created by Federico Torres on 15/10/25.
//

import Combine
import CoreInterfaces
import SwiftUI

/// Navigation controller for the Issues module.
/// Publishes navigation actions for other controllers to listen to.
final class IssuesNavigationController {
    private let path: Binding<NavigationPath>
    private let navigation: IssuesNavigation
    private let resultBus: NavigationResultBus
    private var cancellables = Set<AnyCancellable>()
    
    init(
        path: Binding<NavigationPath>,
        navigation: IssuesNavigation,
        resultBus: NavigationResultBus
    ) {
        self.path = path
        self.navigation = navigation
        self.resultBus = resultBus
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
        case .issueSelected(let issue):
            // Publish result to bus instead of directly handling it
            resultBus.publish(.issueSelected(issue))
        case .cancelTapped:
            resultBus.publish(.issueSelected(nil))
        }
    }
}

