//
//  IssuesListLiveRepository.swift
//  modularizediOSApp
//
//  Created by Federico Torres on 13/10/25.
//  Copyright © 2025 orgName. All rights reserved.
//
import Issues
import ComposableArchitecture
import CoreInterfaces
import Foundation
import shared

typealias IssuesListFoundationRepository = shared.IssuesListRepository

/// 'Live' implementation of IssuesListRepositoryProtocol
public struct IssuesListLiveRepository: IssuesListRepositoryProtocol, @unchecked Sendable {
    
    private let foundationRepository: IssuesListFoundationRepository = IssuesListRepositoryImpl()
    
    public init() {
    }
    
    public func getAllIssues() -> AsyncStream<[CoreInterfaces.IssueUIModel]> {
        return AsyncStream { continuation in
            let job = Task {
                do {
                    for await issuesList in foundationRepository.getAllIssues() {
                        let uiModels = issuesList.map { convertToSwiftModel(issue: $0) }
                        continuation.yield(uiModels)
                    }
                    continuation.finish()
                }
            }
            
            continuation.onTermination = { @Sendable _ in
                job.cancel()
            }
        }
    }
    
    private func convertToSwiftModel(issue: IssueModel) -> IssueUIModel {
        return IssueUIModel(
            id: issue.id,
            title: issue.title,
            description: issue.description_,
            status: issue.status
        )
    }
}

// MARK: - Dependency Override
extension Issues.IssuesListRepository: DependencyKey {
    public static var liveValue: Issues.IssuesListRepository {
        return Self(
            getAllIssues: {
                let repository = IssuesListLiveRepository()
                return repository.getAllIssues()
            }
        )
    }
}

