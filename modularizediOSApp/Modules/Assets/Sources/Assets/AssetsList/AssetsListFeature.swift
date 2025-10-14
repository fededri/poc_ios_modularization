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
        
        public init(
            assets: [AssetUIModel] = [],
            isLoading: Bool = false,
            errorMessage: String? = nil
        ) {
            self.assets = assets
            self.isLoading = isLoading
            self.errorMessage = errorMessage
        }
    }
    
    public enum Action {
        case onAppear
        case assetsResponse([AssetUIModel])
        case errorOccurred(String)
        case assetTapped(id: String)
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
            }
        }
    }
}

