//
//  NavigationContinuationManager.swift
//  modularizediOSApp
//
//  Created by Federico Torres on 15/10/25.
//

import SwiftUI

/// Manages async navigation with continuations that are lifecycle-aware.
/// Controllers should call checkPathState() in their regular result handling.
final class NavigationContinuationManager<Result: Sendable>: @unchecked Sendable {
    private var continuation: CheckedContinuation<Result?, Never>?
    private var expectedPathCount: Int?
    
    /// Start async navigation by appending to path and awaiting result.
    func navigate(
        path: Binding<NavigationPath>,
        append destination: any Hashable
    ) async -> Result? {
        // Defensive: clean up any existing continuation
        if continuation != nil {
            continuation?.resume(returning: nil)
            continuation = nil
        }
        
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            self.expectedPathCount = path.wrappedValue.count + 1
            path.wrappedValue.append(destination)
        }
    }
    
    /// Complete navigation with a result and pop from path.
    func complete(with result: Result, path: Binding<NavigationPath>) {
        continuation?.resume(returning: result)
        cleanup()
        path.wrappedValue.removeLast()
    }
    
    /// Check if path was popped by Back button and clean up if needed.
    func checkPathState(currentCount: Int) {
        guard let expectedCount = expectedPathCount,
              currentCount < expectedCount,
              continuation != nil else {
            return
        }
        
        // Path was popped by Back - clean up
        continuation?.resume(returning: nil)
        cleanup()
    }
    
    private func cleanup() {
        continuation = nil
        expectedPathCount = nil
    }
}

