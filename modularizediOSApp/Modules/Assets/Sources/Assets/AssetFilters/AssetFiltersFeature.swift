//
//  AssetFiltersFeature.swift
//  Assets
//
//  Created by Cursor on 14/10/25.
//

import ComposableArchitecture
import CoreInterfaces
import Foundation

@Reducer
public struct AssetFiltersFeature: Sendable {
    
    @ObservableState
    public struct State: Equatable {
        var selectedStatuses: Set<String> = []
        var selectedCategories: Set<String> = []
        var availableStatuses = ["Active", "Inactive", "Maintenance", "Retired"]
        var availableCategories = ["Equipment", "Furniture", "Vehicles", "Electronics"]
        
        public init(
            selectedStatuses: Set<String> = [],
            selectedCategories: Set<String> = []
        ) {
            self.selectedStatuses = selectedStatuses
            self.selectedCategories = selectedCategories
        }
    }
    
    public enum Action {
        case statusToggled(String)
        case categoryToggled(String)
        case applyFilters
        case clearFilters
        case dismiss
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .statusToggled(status):
                if state.selectedStatuses.contains(status) {
                    state.selectedStatuses.remove(status)
                } else {
                    state.selectedStatuses.insert(status)
                }
                return .none
                
            case let .categoryToggled(category):
                if state.selectedCategories.contains(category) {
                    state.selectedCategories.remove(category)
                } else {
                    state.selectedCategories.insert(category)
                }
                return .none
                
            case .applyFilters:
                // Parent will handle dismissing and applying filters
                return .none
                
            case .clearFilters:
                state.selectedStatuses = []
                state.selectedCategories = []
                return .none
                
            case .dismiss:
                // Parent will handle dismissing
                return .none
            }
        }
    }
}

