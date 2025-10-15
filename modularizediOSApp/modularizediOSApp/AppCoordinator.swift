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
/// Must conform to Hashable since Destinations will be pushed into a NavigationPath to navigate between screens.
enum Destination: Hashable {
    case assetDetail(assetId: String)
    case issuesListPicker
    
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

/// AppCoordinator is a simple container for navigation state and controllers.
/// All navigation logic has been moved to per-module navigation controllers.
@Observable
final class AppCoordinator {
    var path = NavigationPath()
    
    // Module navigation publishers (for features to send actions)
    let assetsNavigation = AssetsNavigation()
    let issuesNavigation = IssuesNavigation()
    
    // Centralized result bus for navigation results
    private let resultBus = NavigationResultBus()
    
    // Navigation controllers (handle navigation logic)
    private(set) var assetsNavigationController: AssetsNavigationController?
    private(set) var issuesNavigationController: IssuesNavigationController?
    
    init() {}
    
    /// Initialize navigation controllers with path binding.
    /// Must be called after the view has access to the path binding.
    func setupControllers(pathBinding: Binding<NavigationPath>) {
        issuesNavigationController = IssuesNavigationController(
            path: pathBinding,
            navigation: issuesNavigation,
            resultBus: resultBus
        )
        
        assetsNavigationController = AssetsNavigationController(
            path: pathBinding,
            navigation: assetsNavigation,
            resultBus: resultBus
        )
    }
}
