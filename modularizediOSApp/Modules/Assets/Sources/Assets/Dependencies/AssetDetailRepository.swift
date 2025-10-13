//
//  AssetDetailRepository.swift
//  Assets
//
//  Created by Federico Torres on 13/10/25.
//

import ComposableArchitecture
import CoreInterfaces
import Foundation

public struct AssetDetailRepository: Sendable {
    public var getAssetDetail: @Sendable (String) -> AsyncStream<AssetDetailUIModel?>
    
    public init(getAssetDetail: @escaping @Sendable (String) -> AsyncStream<AssetDetailUIModel?>) {
        self.getAssetDetail = getAssetDetail
    }
}

extension AssetDetailRepository: TestDependencyKey {
    public static var testValue: AssetDetailRepository {
        return Self(
            getAssetDetail: { id in
                return AsyncStream { continuation in
                    continuation.yield(
                        AssetDetailUIModel(
                            id: id,
                            name: "Test Asset",
                            status: "Active",
                            category: AssetCategoryType(id: "1", name: "Test Category"),
                            description: "Test description",
                            location: "Test location",
                            purchaseDate: "2023-01-01",
                            value: "$1,000.00",
                            manufacturer: "Test Manufacturer",
                            serialNumber: "TEST-001"
                        )
                    )
                    continuation.finish()
                }
            }
        )
    }
}

public extension DependencyValues {
    var assetDetailRepository: AssetDetailRepository {
        get { self[AssetDetailRepository.self] }
        set { self[AssetDetailRepository.self] = newValue }
    }
}

