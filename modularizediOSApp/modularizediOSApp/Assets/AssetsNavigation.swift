//
//  AssetsNavigation.swift
//  modularizediOSApp
//
//  Created by Cursor on 15/10/25.
//

import Combine
import CoreInterfaces
import Foundation

/// Navigation publisher for the Assets module.
/// Publishes navigation events from Assets features to the AppCoordinator.
final class AssetsNavigation {
    
    /// All possible navigation actions from the Assets module
    enum Action {
        case assetTapped(id: String)
        case linkIssueTapped
    }
    
    /// Single publisher that emits all navigation actions
    let publisher = PassthroughSubject<Action, Never>()
    
    init() {}
}

