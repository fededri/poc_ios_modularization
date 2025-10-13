//
//  AssetDetailRepositoryProtocol.swift
//  CoreInterfaces
//
//  Created by Federico Torres on 13/10/25.
//

import Foundation

public protocol AssetDetailRepositoryProtocol: Sendable {
    func getAssetDetail(id: String) -> AsyncStream<AssetDetailUIModel?>
}

