//
//  File.swift
//  CoreInterfaces
//
//  Created by Federico Torres on 09/10/25.
//

import Foundation

public protocol OrdersRepositoryProtocol: Sendable {
    func getAllAssets() -> AsyncStream<[AssetModel]>
}
