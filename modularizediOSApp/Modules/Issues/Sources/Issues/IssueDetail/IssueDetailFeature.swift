//
//  IssueDetailFeature.swift
//  Issues
//
//  Created by Federico Torres on 13/10/25.
//

import ComposableArchitecture
import CoreInterfaces
import Foundation

@Reducer
struct IssueDetailFeature {
    @Dependency(\.issueDetailRepository) var issueDetailRepository
    
    @ObservableState
    struct State: Equatable {
        let issueId: String
        var issueDetail: IssueDetailUIModel?
        var isLoading: Bool = false
        var errorMessage: String?
        
        init(
            issueId: String,
            issueDetail: IssueDetailUIModel? = nil,
            isLoading: Bool = false,
            errorMessage: String? = nil
        ) {
            self.issueId = issueId
            self.issueDetail = issueDetail
            self.isLoading = isLoading
            self.errorMessage = errorMessage
        }
    }
    
    enum Action {
        case onAppear
        case issueDetailResponse(IssueDetailUIModel?)
        case errorOccurred(String)
    }
    
    init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { [issueId = state.issueId] send in
                    for await issueDetail in issueDetailRepository.getIssueDetail(issueId) {
                        await send(.issueDetailResponse(issueDetail))
                    }
                }
                
            case let .issueDetailResponse(issueDetail):
                state.isLoading = false
                if let issueDetail = issueDetail {
                    state.issueDetail = issueDetail
                } else {
                    state.errorMessage = "Issue not found"
                }
                return .none
                
            case let .errorOccurred(message):
                state.isLoading = false
                state.errorMessage = message
                return .none
            }
        }
    }
}

