//
//  AssetsListRepository.swift
//
//  Created by Federico Torres on 11/10/25.
//
import ComposableArchitecture
import CoreInterfaces
import Foundation

public struct AssetsListRepository: Sendable {
    public var getAllAssets: @Sendable () -> AsyncStream<[AssetUIModel]>
    
    public init(getAllAssets: @escaping @Sendable () -> AsyncStream<[AssetUIModel]>) {
        self.getAllAssets = getAllAssets
    }
}

extension AssetsListRepository: DependencyKey {
    public static let liveValue = AssetsListRepository(
        getAllAssets: {
            fatalError("AssetsListRepository.getAllAssets - Override this dependency in your app")
        }
    )
}

public extension DependencyValues {
    var assetsListRepository: AssetsListRepository {
        get { self[AssetsListRepository.self] }
        set { self[AssetsListRepository.self] = newValue }
    }
}
