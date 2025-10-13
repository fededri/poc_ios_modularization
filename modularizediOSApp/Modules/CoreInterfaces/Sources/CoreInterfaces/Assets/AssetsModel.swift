//
//  AssetsModel.swift
//  CoreInterfaces
//
//  Created by Federico Torres on 09/10/25.
//

import Foundation

public struct AssetUIModel: Identifiable, Equatable, Sendable {
    public let id: String
    public let status: String
    public let category: AssetCategoryType
    
    public init(id: String,status: String, category: AssetCategoryType) {
        self.id = id
        self.status = status
        self.category = category
    }
}

public struct AssetCategoryType: Equatable, Sendable {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
