//
//  AssetListRepository.swift
//  Assets
//
//  Created by Federico Torres on 09/10/25.
//
import CoreInterfaces
import Foundation

/// Mock implementation of AssetListRepository
/// For KMP integration with SKIE, see AssetListRepositoryKMP.swift
public struct AssetListRepository: AssetsListRepositoryProtocol {
    
    public init() {}
    
    // TODO: move to main target and re-use KMP repository
    public func getAllAssets() -> AsyncStream<[CoreInterfaces.AssetModel]> {
        AsyncStream { continuation in
            let task = Task {
                // Emit sample data every 2 seconds
                while !Task.isCancelled {
                    let mockAssets = Self.generateMockAssets()
                    continuation.yield(mockAssets)
                    
                    try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
                }
                continuation.finish()
            }
            
            // Handle cancellation
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }
    
    private static func generateMockAssets() -> [CoreInterfaces.AssetModel] {
        return [
            CoreInterfaces.AssetModel(
                id: "1",
                registrationDate: Date(),
                status: "Active",
                category: CoreInterfaces.AssetCategoryType(
                    id: "cat1",
                    name: "Category A"
                )
            ),
            CoreInterfaces.AssetModel(
                id: "2",
                registrationDate: Date().addingTimeInterval(-86400), // Yesterday
                status: "Inactive",
                category: CoreInterfaces.AssetCategoryType(
                    id: "cat2",
                    name: "Category B"
                )
            ),
            CoreInterfaces.AssetModel(
                id: "3",
                registrationDate: Date().addingTimeInterval(-172800), // 2 days ago
                status: "Pending",
                category: CoreInterfaces.AssetCategoryType(
                    id: "cat1",
                    name: "Category A"
                )
            )
        ]
    }
}
