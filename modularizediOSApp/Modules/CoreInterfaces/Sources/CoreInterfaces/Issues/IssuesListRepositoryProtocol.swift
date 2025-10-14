//
//  IssuesListRepositoryProtocol.swift
//  CoreInterfaces
//
//  Created by Federico Torres on 13/10/25.
//

import Foundation

public protocol IssuesListRepositoryProtocol: Sendable {
    func getAllIssues() -> AsyncStream<[IssueUIModel]>
}

