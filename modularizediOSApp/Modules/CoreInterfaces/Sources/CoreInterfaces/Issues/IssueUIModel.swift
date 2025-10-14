//
//  IssueUIModel.swift
//  CoreInterfaces
//
//  Created by Federico Torres on 13/10/25.
//

import Foundation

public struct IssueUIModel: Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let description: String
    public let status: String
    
    public init(
        id: String,
        title: String,
        description: String,
        status: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.status = status
    }
}

