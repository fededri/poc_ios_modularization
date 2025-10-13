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

extension AssetsListRepository: TestDependencyKey {
    public static var testValue: AssetsListRepository {
        return Self(
            getAllAssets: {
                return AsyncStream { continuation in
                    continuation.yield([
                        AssetUIModel(id: "TEST", status: "TEST", category: AssetCategoryType(id: "1", name: "category 1")),
                        AssetUIModel(id: "2", status: "inactive", category: AssetCategoryType(id: "2", name: "category 2"))
                    ])
                    continuation.finish()
                }
            }
        )
    }
}

public extension DependencyValues {
    var assetsListRepository: AssetsListRepository {
        get { self[AssetsListRepository.self] }
        set { self[AssetsListRepository.self] = newValue }
    }
}
