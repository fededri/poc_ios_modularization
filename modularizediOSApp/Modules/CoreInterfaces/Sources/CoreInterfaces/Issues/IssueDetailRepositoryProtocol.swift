//
//  IssueDetailRepositoryProtocol.swift
//  CoreInterfaces
//
//  Created by Federico Torres on 13/10/25.
//

import Foundation

public protocol IssueDetailRepositoryProtocol: Sendable {
    func getIssueDetail(id: String) -> AsyncStream<IssueDetailUIModel?>
}

