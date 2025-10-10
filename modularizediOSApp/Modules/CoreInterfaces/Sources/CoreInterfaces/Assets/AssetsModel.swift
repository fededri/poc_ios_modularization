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
}

public struct AssetCategoryType {
    public let id: String
    public let name: String
}
