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
    
    private let issuePickerManager = NavigationContinuationManager<IssueUIModel>()
    
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
        // Subscribe to own navigation actions
        navigation.publisher
            .sink { [weak self] action in
                self?.handle(action)
            }
            .store(in: &cancellables)
        
        // Subscribe to results from result bus (not from IssuesNavigation!)
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
            // Deprecated - use async navigateToIssuesPicker() instead
            break
        }
    }
    
    private func handleResult(_ result: NavigationResultBus.Result) {
        // Check if path was popped by Back button
        issuePickerManager.checkPathState(currentCount: path.wrappedValue.count)
        
        switch result {
        case .issueSelected(let issue):
            if let issue = issue {
                issuePickerManager.complete(with: issue, path: path)
            } else {
                // Cancelled - simulate a pop to trigger cleanup
                issuePickerManager.checkPathState(currentCount: path.wrappedValue.count - 1)
            }
        default:
            break
        }
    }
    
    // MARK: - Async Navigation Methods
    
    /// Navigate to issue picker and await selected issue.
    /// Returns the selected issue or nil if cancelled.
    func navigateToIssuesPicker() async -> IssueUIModel? {
        return await issuePickerManager.navigate(
            path: path,
            append: Destination.issuesListPicker
        )
    }
}

