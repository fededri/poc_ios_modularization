//
//  IssuesNavigation.swift
//  modularizediOSApp
//
//  Created by Cursor on 15/10/25.
//

import Combine
import CoreInterfaces
import Foundation

/// Navigation publisher for the Issues module.
/// Publishes navigation events from Issues features to the AppCoordinator.
final class IssuesNavigation {
    
    /// All possible navigation actions from the Issues module
    enum Action {
        case issueSelected(IssueUIModel)
        case cancelTapped
    }
    
    /// Single publisher that emits all navigation actions
    let publisher = PassthroughSubject<Action, Never>()
    
    init() {}
}

