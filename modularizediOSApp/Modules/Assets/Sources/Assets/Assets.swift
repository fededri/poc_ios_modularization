//
//  Assets.swift
//  Assets
//
//  Created by Federico Torres on 11/10/25.
//

// Main module file for Assets package
// All public types are automatically exported by Swift Package Manager

import ComposableArchitecture
import CoreInterfaces
import SwiftUI

public struct AssetsListProvider: ViewProviding {
    public init() {
    }
    
    @MainActor public func make() -> some View {
        AssetsListView(
            store: Store(initialState: AssetsListFeature.State()) {
                AssetsListFeature()
            }
        )
    }
}
