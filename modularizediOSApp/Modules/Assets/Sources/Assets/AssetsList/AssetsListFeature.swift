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
struct AssetsListFeature {
    @Dependency(\.assetsListRepository) var assetsListRepository
    
    @ObservableState
    struct State: Equatable {
        var assets: [AssetUIModel] = []
        var isLoading: Bool = false
        var errorMessage: String?
        @Presents var destination: Destination.State?
        
        init(
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
    
    enum Action {
        case onAppear
        case assetsResponse([AssetUIModel])
        case errorOccurred(String)
        case assetTapped(id: String)
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Reducer(state: .equatable)
    enum Destination {
        case assetDetail(AssetDetailFeature)
    }
        
    init() {}
    
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
                
            case let .assetTapped(id):
                state.destination = .assetDetail(AssetDetailFeature.State(assetId: id))
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

