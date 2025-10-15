//
//  AppCoordinator.swift
//  modularizediOSApp
//
//  Created by Cursor on 14/10/25.
//

import Combine
import CoreInterfaces
import Foundation
import Observation
import SwiftUI

/// Destination enum for type-safe navigation routing.
/// Used with NavigationPath to navigate between screens.
enum Destination: Hashable {
    case assetDetail(assetId: String)
    case issuesListPicker
    
    static func == (lhs: Destination, rhs: Destination) -> Bool {
        switch (lhs, rhs) {
        case (.assetDetail(let id1), .assetDetail(let id2)):
            return id1 == id2
        case (.issuesListPicker, .issuesListPicker):
            return true
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .assetDetail(let id):
            hasher.combine("assetDetail")
            hasher.combine(id)
        case .issuesListPicker:
            hasher.combine("issuesListPicker")
        }
    }
}

/// AppCoordinator manages app-wide navigation using vanilla SwiftUI and Observation framework.
/// It bridges TCA feature modules with Apple's NavigationStack using Combine publishers.
@Observable
final class AppCoordinator {
    var path = NavigationPath()
    var selectedIssueForAsset: IssueUIModel?
    
    // Each module has its own navigation publisher
    let assetsNavigation: AssetsNavigation
    let issuesNavigation: IssuesNavigation
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        assetsNavigation: AssetsNavigation = AssetsNavigation(),
        issuesNavigation: IssuesNavigation = IssuesNavigation()
    ) {
        self.assetsNavigation = assetsNavigation
        self.issuesNavigation = issuesNavigation
        setupNavigationSubscriptions()
    }
    
    private func setupNavigationSubscriptions() {
        // Subscribe to Assets module navigation - single publisher for all actions
        assetsNavigation.publisher
            .sink { [weak self] action in
                self?.handleAssetsAction(action)
            }
            .store(in: &cancellables)
        
        // Subscribe to Issues module navigation - single publisher for all actions
        issuesNavigation.publisher
            .sink { [weak self] action in
                self?.handleIssuesAction(action)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Action Handlers
    
    private func handleAssetsAction(_ action: AssetsNavigation.Action) {
        switch action {
        case .assetTapped(let id):
            navigateToAssetDetail(assetId: id)
        case .linkIssueTapped:
            navigateToIssuesPicker()
        }
    }
    
    private func handleIssuesAction(_ action: IssuesNavigation.Action) {
        switch action {
        case .issueSelected(let issue):
            handleIssueSelected(issue)
        case .cancelTapped:
            path.removeLast()
        }
    }
    
    // MARK: - Navigation Methods
    
    func navigateToAssetDetail(assetId: String) {
        path.append(Destination.assetDetail(assetId: assetId))
    }
    
    func navigateToIssuesPicker() {
        path.append(Destination.issuesListPicker)
    }
    
    func handleIssueSelected(_ issue: IssueUIModel) {
        selectedIssueForAsset = issue
        path.removeLast() // Pop back to asset detail
    }
}
