//
//  AssetDetailFeature.swift
//  Assets
//
//  Created by Federico Torres on 13/10/25.
//

import ComposableArchitecture
import CoreInterfaces
import Foundation

@Reducer
struct AssetDetailFeature {
    @Dependency(\.assetDetailRepository) var assetDetailRepository
    
    @ObservableState
    struct State: Equatable {
        let assetId: String
        var assetDetail: AssetDetailUIModel?
        var isLoading: Bool = false
        var errorMessage: String?
        
        init(
            assetId: String,
            assetDetail: AssetDetailUIModel? = nil,
            isLoading: Bool = false,
            errorMessage: String? = nil
        ) {
            self.assetId = assetId
            self.assetDetail = assetDetail
            self.isLoading = isLoading
            self.errorMessage = errorMessage
        }
    }
    
    enum Action {
        case onAppear
        case assetDetailResponse(AssetDetailUIModel?)
        case errorOccurred(String)
    }
    
    init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { [assetId = state.assetId] send in
                    for await assetDetail in assetDetailRepository.getAssetDetail(assetId) {
                        await send(.assetDetailResponse(assetDetail))
                    }
                }
                
            case let .assetDetailResponse(assetDetail):
                state.isLoading = false
                if let assetDetail = assetDetail {
                    state.assetDetail = assetDetail
                } else {
                    state.errorMessage = "Asset not found"
                }
                return .none
                
            case let .errorOccurred(message):
                state.isLoading = false
                state.errorMessage = message
                return .none
            }
        }
    }
}

