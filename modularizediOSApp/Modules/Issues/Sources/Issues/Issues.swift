//
//  Issues.swift
//  Issues
//
//  Created by Federico Torres on 13/10/25.
//

import ComposableArchitecture
import CoreInterfaces
import SwiftUI

public struct IssuesListPickerProvider {
    private let onResult: (IssueUIModel) -> Void
    
    public init(onResult: @escaping (IssueUIModel) -> Void) {
        self.onResult = onResult
    }
    
   @MainActor
    public func make() -> some View {
        IssuesListPickerView(
            store: Store(initialState: IssuesListPickerFeature.State()) {
                IssuesListPickerFeature()
            },
            onIssueSelected: { issue in
                onResult(issue)
            }
        )
    }
}
