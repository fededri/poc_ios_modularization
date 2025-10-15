//
//  ActionObserver.swift
//  modularizediOSApp
//
//  Created by Federico Torres on 15/10/25.
//

import ComposableArchitecture
import Foundation

/// A reducer that wraps another reducer and observes actions before they're processed.
/// This allows us to bridge TCA actions to Combine publishers without modifying feature modules.
struct ActionObserver<R: Reducer>: Reducer {
    let base: R
    let observe: (R.Action) -> Void
    
    var body: some ReducerOf<R> {
        Reduce { state, action in
            // Observe the action first
            observe(action)
            // Then pass it to the base reducer
            return .none
        }
        base
    }
}

extension Reducer {
    /// Wraps this reducer with action observation.
    func observeActions(_ observe: @escaping (Action) -> Void) -> some Reducer<State, Action> {
        ActionObserver(base: self, observe: observe)
    }
}

