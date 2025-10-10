//
//  AssetsModel.swift
//  CoreInterfaces
//
//  Created by Federico Torres on 09/10/25.
//

import Foundation

public struct AssetModel: Identifiable {
    public let id: String
    public let registrationDate: Date
    public let status: String
    public let category: AssetCategoryType
    
    public init(id: String, registrationDate: Date, status: String, category: AssetCategoryType) {
        self.id = id
        self.registrationDate = registrationDate
        self.status = status
        self.category = category
    }
}

public struct AssetCategoryType {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
