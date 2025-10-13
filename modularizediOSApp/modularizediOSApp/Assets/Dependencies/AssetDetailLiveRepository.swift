//
//  AssetDetailLiveRepository.swift
//  modularizediOSApp
//
//  Created by Federico Torres on 13/10/25.
//  Copyright © 2025 orgName. All rights reserved.
//
import Assets
import ComposableArchitecture
import CoreInterfaces
import Foundation
import shared

typealias AssetDetailFoundationRepository = shared.AssetDetailRepository

/// 'Live' implementation of AssetDetailRepositoryProtocol
public struct AssetDetailLiveRepository: AssetDetailRepositoryProtocol, @unchecked Sendable {
    
    private let foundationRepository: AssetDetailFoundationRepository = AssetDetailRepositoryImpl()
    
    public init() {
    }
    
    public func getAssetDetail(id: String) -> AsyncStream<CoreInterfaces.AssetDetailUIModel?> {
        return AsyncStream { continuation in
            let job = Task {
                do {
                    for await assetDetail in foundationRepository.getAssetDetail(id: id) {
                        if let assetDetail = assetDetail {
                            let uiModel = convertToSwiftModel(assetDetail: assetDetail)
                            continuation.yield(uiModel)
                        } else {
                            continuation.yield(nil)
                        }
                    }
                    continuation.finish()
                }
            }
            
            continuation.onTermination = { @Sendable _ in
                job.cancel()
            }
        }
    }
    
    private func convertToSwiftModel(assetDetail: AssetDetailModel) -> AssetDetailUIModel {
        return AssetDetailUIModel(
            id: assetDetail.id,
            name: assetDetail.name,
            status: assetDetail.status,
            category: AssetCategoryType(
                id: assetDetail.category.id,
                name: assetDetail.category.name
            ),
            description: assetDetail.description_,
            location: assetDetail.location,
            purchaseDate: assetDetail.purchaseDate,
            value: assetDetail.value,
            manufacturer: assetDetail.manufacturer,
            serialNumber: assetDetail.serialNumber
        )
    }
}

// MARK: - Dependency Override
extension Assets.AssetDetailRepository: DependencyKey {
    public static var liveValue: Assets.AssetDetailRepository {
        return Self(
            getAssetDetail: { id in
                let repository = AssetDetailLiveRepository()
                return repository.getAssetDetail(id: id)
            }
        )
    }
}
