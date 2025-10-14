//
//  AppCoordinator.swift
//  modularizediOSApp
//
//  Created by Cursor on 14/10/25.
//

import Assets
import ComposableArchitecture
import CoreInterfaces
import Foundation
import Issues

@Reducer
struct AppCoordinator {
    
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var assetsList = AssetsListFeature.State()
        
        init(
            path: StackState<Path.State> = StackState<Path.State>(),
            assetsList: AssetsListFeature.State = AssetsListFeature.State()
        ) {
            self.path = path
            self.assetsList = assetsList
        }
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case assetsList(AssetsListFeature.Action)
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case assetDetail(AssetDetailFeature)
        case issuesListPicker(IssuesListPickerFeature)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.assetsList, action: \.assetsList) {
            AssetsListFeature()
        }
        
        Reduce { state, action in
            switch action {
            // Handle navigation from AssetsList to AssetDetail
            case let .assetsList(.assetTapped(id)):
                state.path.append(.assetDetail(AssetDetailFeature.State(assetId: id)))
                return .none
                
            // Handle navigation from AssetDetail to IssuesListPicker
            case .path(.element(id: _, action: .assetDetail(.linkIssueTapped))):
                state.path.append(.issuesListPicker(IssuesListPickerFeature.State()))
                return .none
                
            // Handle issue selection from IssuesListPicker
            case let .path(.element(id: _, action: .issuesListPicker(.issueSelected(issue)))):
                // Find the AssetDetail in the path and update it with the selected issue
                for id in state.path.ids {
                    if case .assetDetail(var assetDetailState) = state.path[id: id] {
                        assetDetailState.linkedIssue = issue
                        state.path[id: id] = .assetDetail(assetDetailState)
                        break
                    }
                }
                // Pop back to asset detail
                state.path.removeLast()
                return .none
                
            // Handle cancel from IssuesListPicker
            case .path(.element(id: _, action: .issuesListPicker(.cancelTapped))):
                state.path.removeLast()
                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

