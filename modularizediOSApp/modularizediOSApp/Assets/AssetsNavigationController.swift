//
//  AssetsNavigationController.swift
//  modularizediOSApp
//
//  Created by Federico Torres on 15/10/25.
//

import Assets
import Combine
import CoreInterfaces
import SwiftUI

/// Navigation controller for the Assets module.
/// Handles navigation logic and exposes async methods for result-returning navigation.
final class AssetsNavigationController: @unchecked Sendable, AssetsNavigationControllerProtocol {
    private let path: Binding<NavigationPath>
    private let navigation: AssetsNavigation
    private let resultBus: NavigationResultBus
    private var cancellables = Set<AnyCancellable>()
    
    // Single manager for all async navigation operations
    private let navigationManager = NavigationContinuationManager()
    
    init(
        path: Binding<NavigationPath>,
        navigation: AssetsNavigation,
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
        
        // Subscribe to results
        resultBus.results
            .sink { [weak self] result in
                self?.handleResult(result)
            }
            .store(in: &cancellables)
    }
    
    private func handle(_ action: AssetsNavigation.Action) {
        switch action {
        case .assetTapped(let id):
            path.wrappedValue.append(Destination.assetDetail(assetId: id))
        case .linkIssueTapped:
            break
        }
    }
    
    private func handleResult(_ result: NavigationResultBus.Result) {
        // Early exit: only process if we have active navigation
        guard navigationManager.hasActiveNavigation else {
            return
        }
        
        // Check if path was popped by Back button
        if navigationManager.checkPathState(currentCount: path.wrappedValue.count) {
            return
        }
        
        switch result {
        case .issueSelected(let issue):
            if let issue = issue {
                navigationManager.complete(with: issue, path: path)
            } else {
                navigationManager.cancel(path: path)
            }
        default:
            break
        }
    }
    
    // MARK: - Async Navigation Methods
    
    /// Navigate to issue picker and await selected issue.
    /// Returns the selected issue or nil if cancelled.
    func navigateToIssuesPicker() async -> IssueUIModel? {
        return await navigationManager.navigate(
            path: path,
            append: Destination.issuesListPicker,
            resultType: IssueUIModel.self
        )
    }
}

