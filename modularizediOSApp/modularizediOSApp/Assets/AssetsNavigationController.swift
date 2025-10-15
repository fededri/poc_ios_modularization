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
/// Conforms to AssetsNavigationControllerProtocol defined in CoreInterfaces.
final class AssetsNavigationController: @unchecked Sendable, AssetsNavigationControllerProtocol {
    private let path: Binding<NavigationPath>
    private let navigation: AssetsNavigation
    private let issuesNavigation: IssuesNavigation
    private var cancellables = Set<AnyCancellable>()
    
    // Continuation for async issue picker
    private var issuePickerContinuation: CheckedContinuation<IssueUIModel?, Never>?
    
    init(
        path: Binding<NavigationPath>,
        navigation: AssetsNavigation,
        issuesNavigation: IssuesNavigation
    ) {
        self.path = path
        self.navigation = navigation
        self.issuesNavigation = issuesNavigation
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        // Handle fire-and-forget navigation from Assets features
        navigation.publisher
            .sink { [weak self] action in
                self?.handle(action)
            }
            .store(in: &cancellables)
        
        // Listen for results from Issues picker
        issuesNavigation.publisher
            .sink { [weak self] action in
                self?.handleIssuesAction(action)
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
    
    private func handleIssuesAction(_ action: IssuesNavigation.Action) {
        switch action {
        case .issueSelected(let issue):
            issuePickerContinuation?.resume(returning: issue)
            issuePickerContinuation = nil
            path.wrappedValue.removeLast()
        case .cancelTapped:
            issuePickerContinuation?.resume(returning: nil)
            issuePickerContinuation = nil
            path.wrappedValue.removeLast()
        }
    }
    
    // MARK: - Async Navigation Methods
    
    /// Navigate to issue picker and await selected issue.
    /// Returns the selected issue or nil if cancelled.
    func navigateToIssuesPicker() async -> IssueUIModel? {
        return await withCheckedContinuation { continuation in
            issuePickerContinuation = continuation
            path.wrappedValue.append(Destination.issuesListPicker)
        }
    }
}

