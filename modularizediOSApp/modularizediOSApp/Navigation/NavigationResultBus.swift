//
//  NavigationResultBus.swift
//  modularizediOSApp
//
//  Created by Federico Torres on 15/10/25.
//

import Combine
import CoreInterfaces

/// Centralized bus for navigation results.
/// Controllers publish results here and subscribe to results they need.
/// This eliminates circular dependencies between controllers.
final class NavigationResultBus {
    
    /// All possible navigation result types
    enum Result {
        case issueSelected(IssueUIModel?)
        case assetSelected(AssetUIModel?)
        case barcodeScanComplete(String?)
        // Add more result types as needed
    }
    
    private let resultPublisher = PassthroughSubject<Result, Never>()
    
    /// Subscribe to navigation results
    var results: AnyPublisher<Result, Never> {
        resultPublisher.eraseToAnyPublisher()
    }
    
    /// Publish a navigation result
    func publish(_ result: Result) {
        resultPublisher.send(result)
    }
    
    init() {}
}

