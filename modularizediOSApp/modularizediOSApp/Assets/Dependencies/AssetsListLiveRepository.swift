//
//  AssetsListLiveRepository.swift
//  modularizediOSApp
//
//  Created by Federico Torres on 11/10/25.
//  Copyright © 2025 orgName. All rights reserved.
//
import Assets
import ComposableArchitecture
import CoreInterfaces
import Foundation
import shared

typealias AssetsListFoundationRepository = shared.AssetListRepository

/// 'Live' implementation of AssetsListRepositoryProtocol
public struct AssetListLiveRepository: AssetsListRepositoryProtocol, @unchecked Sendable {
    
    private let foundationRepository: AssetsListFoundationRepository = AssetListRepositoryImpl()
    
    public init() {
    }
    
    public func getAllAssets() -> AsyncStream<[CoreInterfaces.AssetUIModel]> {
        return AsyncStream { continuation in
            let job = Task {
                do {
                    for await assetsList in foundationRepository.getAllAssets() {
                        let uiModels = assetsList.map { convertToSwiftModel(asset: $0) }
                        continuation.yield(uiModels)
                    }
                    continuation.finish()
                }
            }
            
            continuation.onTermination = { @Sendable _ in
                job.cancel()
            }
        }
    }
    
    private func convertToSwiftModel(asset: AssetModel) -> AssetUIModel {
        return AssetUIModel(
            id: asset.id,
            status: asset.status,
            category: AssetCategoryType(
                id: asset.category.id,
                name: asset.category.name
            )
        )
    }
}

// MARK: - Dependency Override
extension Assets.AssetsListRepository: @retroactive DependencyKey {
    public static var liveValue: Assets.AssetsListRepository {
        return Self(
            getAllAssets: {
                let repository = AssetListLiveRepository()
                return repository.getAllAssets()
            }
        )
    }
}

public extension AssetsListRepository {
    /// Live implementation using the shared KMP repository
    static func live() -> AssetsListRepository {
        let repository = AssetListLiveRepository()
        
        return AssetsListRepository(
            getAllAssets: repository.getAllAssets
        )
    }
}
