//
//  AssetsListFeature.swift
//  Assets
//
//  Created by Federico Torres on 11/10/25.
//

import ComposableArchitecture
import CoreInterfaces
import Foundation

@Reducer
public struct AssetsListFeature : Sendable {
    @Dependency(\.assetsListRepository) var assetsListRepository
    
    @ObservableState
    public struct State: Equatable {
        var assets: [AssetUIModel] = []
        var isLoading: Bool = false
        var errorMessage: String?
        @Presents var destination: Destination.State?
        var selectedStatuses: Set<String> = []
        var selectedCategories: Set<String> = []
        
        public init(
            assets: [AssetUIModel] = [],
            isLoading: Bool = false,
            errorMessage: String? = nil,
            destination: Destination.State? = nil
        ) {
            self.assets = assets
            self.isLoading = isLoading
            self.errorMessage = errorMessage
            self.destination = destination
        }
    }
    
    public enum Action {
        case onAppear
        case assetsResponse([AssetUIModel])
        case errorOccurred(String)
        case assetTapped(id: String)
        case filtersTapped
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
        case filters(AssetFiltersFeature)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { send in
                    for await assets in assetsListRepository.getAllAssets() {
                        await send(.assetsResponse(assets))
                    }
                }
                
            case let .assetsResponse(assets):
                state.isLoading = false
                state.assets = assets
                return .none
                
            case let .errorOccurred(message):
                state.isLoading = false
                state.errorMessage = message
                return .none
                
            case .assetTapped:
                // Coordinator will handle navigation
                return .none
                
            case .filtersTapped:
                // Show filters sheet - pure internal navigation!
                state.destination = .filters(AssetFiltersFeature.State(
                    selectedStatuses: state.selectedStatuses,
                    selectedCategories: state.selectedCategories
                ))
                return .none
                
            case .destination(.presented(.filters(.applyFilters))):
                // Save the filters and dismiss
                if case let .filters(filtersState) = state.destination {
                    state.selectedStatuses = filtersState.selectedStatuses
                    state.selectedCategories = filtersState.selectedCategories
                }
                state.destination = nil
                // In real app: filter the assets list here based on selectedStatuses/Categories
                return .none
                
            case .destination(.presented(.filters(.dismiss))):
                state.destination = nil
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

