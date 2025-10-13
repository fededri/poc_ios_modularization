//
//  IssueDetailUIModel.swift
//  CoreInterfaces
//
//  Created by Federico Torres on 13/10/25.
//

import Foundation

public struct IssueDetailUIModel: Equatable, Sendable {
    public let id: String
    public let title: String
    public let description: String
    public let status: String
    public let assignee: String
    public let priority: String
    public let createdDate: String
    public let dueDate: String
    public let reporter: String
    
    public init(
        id: String,
        title: String,
        description: String,
        status: String,
        assignee: String,
        priority: String,
        createdDate: String,
        dueDate: String,
        reporter: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.status = status
        self.assignee = assignee
        self.priority = priority
        self.createdDate = createdDate
        self.dueDate = dueDate
        self.reporter = reporter
    }
}

