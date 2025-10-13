//
//  IssueDetailLiveRepository.swift
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

typealias IssueDetailFoundationRepository = shared.IssueDetailRepository

/// 'Live' implementation of IssueDetailRepositoryProtocol
public struct IssueDetailLiveRepository: IssueDetailRepositoryProtocol, @unchecked Sendable {
    
    private let foundationRepository: IssueDetailFoundationRepository = IssueDetailRepositoryImpl()
    
    public init() {
    }
    
    public func getIssueDetail(id: String) -> AsyncStream<CoreInterfaces.IssueDetailUIModel?> {
        return AsyncStream { continuation in
            let job = Task {
                do {
                    for await issueDetail in foundationRepository.getIssueDetail(id: id) {
                        if let issueDetail = issueDetail {
                            let uiModel = convertToSwiftModel(issueDetail: issueDetail)
                            continuation.yield(uiModel)
                        } else {
                            continuation.yield(nil)
                        }
                    }
                    continuation.finish()
                }
            }
            
            continuation.onTermination = { @Sendable _ in
                job.cancel()
            }
        }
    }
    
    private func convertToSwiftModel(issueDetail: IssueDetailModel) -> IssueDetailUIModel {
        return IssueDetailUIModel(
            id: issueDetail.id,
            title: issueDetail.title,
            description: issueDetail.description_,
            status: issueDetail.status,
            assignee: issueDetail.assignee,
            priority: issueDetail.priority,
            createdDate: issueDetail.createdDate,
            dueDate: issueDetail.dueDate,
            reporter: issueDetail.reporter
        )
    }
}

// MARK: - Dependency Override
extension Issues.IssueDetailRepository: DependencyKey {
    public static var liveValue: Issues.IssueDetailRepository {
        return Self(
            getIssueDetail: { id in
                let repository = IssueDetailLiveRepository()
                return repository.getIssueDetail(id: id)
            }
        )
    }
}

