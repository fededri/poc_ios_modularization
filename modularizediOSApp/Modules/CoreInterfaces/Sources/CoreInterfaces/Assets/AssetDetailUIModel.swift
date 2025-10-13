//
//  AssetDetailUIModel.swift
//  CoreInterfaces
//
//  Created by Federico Torres on 13/10/25.
//

import Foundation

public struct AssetDetailUIModel: Equatable, Sendable {
    public let id: String
    public let name: String
    public let status: String
    public let category: AssetCategoryType
    public let description: String
    public let location: String
    public let purchaseDate: String
    public let value: String
    public let manufacturer: String
    public let serialNumber: String
    
    public init(
        id: String,
        name: String,
        status: String,
        category: AssetCategoryType,
        description: String,
        location: String,
        purchaseDate: String,
        value: String,
        manufacturer: String,
        serialNumber: String
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.category = category
        self.description = description
        self.location = location
        self.purchaseDate = purchaseDate
        self.value = value
        self.manufacturer = manufacturer
        self.serialNumber = serialNumber
    }
}

