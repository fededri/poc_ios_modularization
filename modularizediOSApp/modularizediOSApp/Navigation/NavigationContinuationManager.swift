//
//  AnyNavigationContinuationManager.swift
//  modularizediOSApp
//
//  Created by Federico Torres on 15/10/25.
//

import SwiftUI

/// Manages async navigation operations with different result types.
/// Only one navigation can be active at a time per manager instance.
final class NavigationContinuationManager {
    
    /// Type-erased continuation storage
    private var activeContinuation: AnyContinuation?
    private var expectedPathCount: Int?
    
    /// Whether there's an active navigation waiting for a result
    var hasActiveNavigation: Bool {
        activeContinuation != nil
    }
    
    /// Start async navigation by appending to path and awaiting result.
    func navigate<Result: Sendable>(
        path: Binding<NavigationPath>,
        append destination: any Hashable,
        resultType: Result.Type
    ) async -> Result? {
        cleanupContinuation(with: nil)
        
        return await withCheckedContinuation { continuation in
            self.activeContinuation = AnyContinuation(
                continuation: continuation,
                resultType: resultType
            )
            self.expectedPathCount = path.wrappedValue.count + 1
            path.wrappedValue.append(destination)
        }
    }
    
    /// Complete navigation with a result and pop from path.
    /// Only processes if the result type matches what we're waiting for.
    func complete<Result: Sendable>(
        with result: Result,
        path: Binding<NavigationPath>
    ) {
        guard let active = activeContinuation,
              active.canHandle(result: result) else {
            return  // Not waiting for this result type
        }
        
        active.resume(with: result)
        cleanup()
        path.wrappedValue.removeLast()
    }
    
    /// Cancel navigation without a result and pop from path.
    func cancel(path: Binding<NavigationPath>) {
        guard activeContinuation != nil else { return }
        cleanupContinuation(with: nil)
        path.wrappedValue.removeLast()
    }
    
    /// Check if path was popped by Back button and clean up if needed.
    /// Returns true if cleanup occurred.
    @discardableResult
    func checkPathState(currentCount: Int) -> Bool {
        guard let expectedCount = expectedPathCount,
              currentCount < expectedCount,
              activeContinuation != nil else {
            return false
        }
        
        // Path was popped by Back - clean up
        cleanupContinuation(with: nil)
        return true
    }
    
    private func cleanupContinuation(with result: Any?) {
        activeContinuation?.resume(with: result)
        cleanup()
    }
    
    private func cleanup() {
        activeContinuation = nil
        expectedPathCount = nil
    }
}

/// Type-erased continuation wrapper
private struct AnyContinuation {
    private let _resume: (Any?) -> Void
    private let _resultTypeName: String
    
    init<Result: Sendable>(
        continuation: CheckedContinuation<Result?, Never>,
        resultType: Result.Type
    ) {
        self._resume = { value in
            continuation.resume(returning: value as? Result)
        }
        self._resultTypeName = String(describing: Result.self)
    }
    
    func canHandle<Result>(result: Result) -> Bool {
        String(describing: Result.self) == _resultTypeName
    }
    
    func resume<Result>(with result: Result) {
        _resume(result)
    }
    
    func resume(with result: Any?) {
        _resume(result)
    }
}

