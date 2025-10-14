//
//  IssuesListRepository.swift
//  Issues
//
//  Created by Federico Torres on 13/10/25.
//

import ComposableArchitecture
import CoreInterfaces
import Foundation

public struct IssuesListRepository: Sendable {
    public var getAllIssues: @Sendable () -> AsyncStream<[IssueUIModel]>
    
    public init(getAllIssues: @escaping @Sendable () -> AsyncStream<[IssueUIModel]>) {
        self.getAllIssues = getAllIssues
    }
}

extension IssuesListRepository: TestDependencyKey {
    public static var testValue: IssuesListRepository {
        return Self(
            getAllIssues: {
                return AsyncStream { continuation in
                    continuation.yield([
                        IssueUIModel(id: "TEST-1", title: "Test Issue 1", description: "Test description", status: "Open"),
                        IssueUIModel(id: "TEST-2", title: "Test Issue 2", description: "Test description", status: "Closed")
                    ])
                    continuation.finish()
                }
            }
        )
    }
}

public extension DependencyValues {
    var issuesListRepository: IssuesListRepository {
        get { self[IssuesListRepository.self] }
        set { self[IssuesListRepository.self] = newValue }
    }
}

