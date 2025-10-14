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
        @ObservationStateIgnored var navigator: (any Navigator)? = nil
        
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
        
        public static func == (lhs: State, rhs: State) -> Bool {
            return lhs.assets == rhs.assets &&
            lhs.isLoading == rhs.isLoading &&
            lhs.errorMessage == rhs.errorMessage
        }
    }
    
    enum Action {
        case onAppear
        case assetsResponse([AssetUIModel])
        case errorOccurred(String)
        case assetTapped(id: String)
        case destination(PresentationAction<Destination.Action>)
        case setNavigator(any Navigator)
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
                
            case .setNavigator(let navigator):
                state.navigator = navigator
                return .none
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
                //state.navigator?.navigate(to: .asset)
                return .none
                
            case .destination(.presented(.assetDetail(.linkIssueTapped))):
                state.navigator?.navigate(to: .issuesListPicker)
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

