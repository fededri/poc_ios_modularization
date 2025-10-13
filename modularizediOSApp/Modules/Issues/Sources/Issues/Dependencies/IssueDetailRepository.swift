//
//  IssueDetailRepository.swift
//  Issues
//
//  Created by Federico Torres on 13/10/25.
//

import ComposableArchitecture
import CoreInterfaces
import Foundation

public struct IssueDetailRepository: Sendable {
    public var getIssueDetail: @Sendable (String) -> AsyncStream<IssueDetailUIModel?>
    
    public init(getIssueDetail: @escaping @Sendable (String) -> AsyncStream<IssueDetailUIModel?>) {
        self.getIssueDetail = getIssueDetail
    }
}

extension IssueDetailRepository: TestDependencyKey {
    public static var testValue: IssueDetailRepository {
        return Self(
            getIssueDetail: { id in
                return AsyncStream { continuation in
                    continuation.yield(
                        IssueDetailUIModel(
                            id: id,
                            title: "Test Issue",
                            description: "Test description",
                            status: "Open",
                            assignee: "Test User",
                            priority: "High",
                            createdDate: "2024-01-01",
                            dueDate: "2024-01-15",
                            reporter: "Test Reporter"
                        )
                    )
                    continuation.finish()
                }
            }
        )
    }
}

public extension DependencyValues {
    var issueDetailRepository: IssueDetailRepository {
        get { self[IssueDetailRepository.self] }
        set { self[IssueDetailRepository.self] = newValue }
    }
}

