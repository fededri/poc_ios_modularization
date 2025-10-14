//
//  IssuesListPickerFeature.swift
//  Issues
//
//  Created by Federico Torres on 13/10/25.
//

import ComposableArchitecture
import CoreInterfaces
import Foundation

@Reducer
struct IssuesListPickerFeature {
    @Dependency(\.issuesListRepository) var issuesListRepository
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        var issues: [IssueUIModel] = []
        var isLoading: Bool = false
        var errorMessage: String?
        @Presents var destination: Destination.State?
        
        init(
            issues: [IssueUIModel] = [],
            isLoading: Bool = false,
            errorMessage: String? = nil,
            destination: Destination.State? = nil
        ) {
            self.issues = issues
            self.isLoading = isLoading
            self.errorMessage = errorMessage
            self.destination = destination
        }
    }
    
    enum Action {
        case onAppear
        case issuesResponse([IssueUIModel])
        case errorOccurred(String)
        case issueTapped(id: String)
        case issueSelected(IssueUIModel)
        case cancelTapped
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Reducer(state: .equatable)
    enum Destination {
        case issueDetail(IssueDetailFeature)
    }
    
    init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { send in
                    for await issues in issuesListRepository.getAllIssues() {
                        await send(.issuesResponse(issues))
                    }
                }
                
            case let .issuesResponse(issues):
                state.isLoading = false
                state.issues = issues
                return .none
                
            case let .errorOccurred(message):
                state.isLoading = false
                state.errorMessage = message
                return .none
                
            case let .issueTapped(id):
                state.destination = .issueDetail(IssueDetailFeature.State(issueId: id))
                return .none
                
            case .issueSelected:
                // Parent will handle the selection through the dismiss effect
                return .run { _ in
                    await dismiss()
                }
                
            case .cancelTapped:
                return .run { _ in
                    await dismiss()
                }
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

