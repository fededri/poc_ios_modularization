//
//  AssetFiltersView.swift
//  Assets
//
//  Created by Cursor on 14/10/25.
//

import ComposableArchitecture
import CoreInterfaces
import SwiftUI

public struct AssetFiltersView: View {
    @Bindable var store: StoreOf<AssetFiltersFeature>
    
    public init(store: StoreOf<AssetFiltersFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Filter assets by status and category")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Section("Status") {
                    ForEach(store.availableStatuses, id: \.self) { status in
                        Toggle(status, isOn: Binding(
                            get: { store.selectedStatuses.contains(status) },
                            set: { _ in store.send(.statusToggled(status)) }
                        ))
                    }
                }
                
                Section("Category") {
                    ForEach(store.availableCategories, id: \.self) { category in
                        Toggle(category, isOn: Binding(
                            get: { store.selectedCategories.contains(category) },
                            set: { _ in store.send(.categoryToggled(category)) }
                        ))
                    }
                }
                
                Section {
                    HStack {
                        Text("Selected: \(store.selectedStatuses.count) statuses, \(store.selectedCategories.count) categories")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if !store.selectedStatuses.isEmpty || !store.selectedCategories.isEmpty {
                            Button("Clear All") {
                                store.send(.clearFilters)
                            }
                            .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Filter Assets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        store.send(.dismiss)
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        store.send(.applyFilters)
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    AssetFiltersView(
        store: Store(
            initialState: AssetFiltersFeature.State(
                selectedStatuses: ["Active"],
                selectedCategories: ["Equipment"]
            )
        ) {
            AssetFiltersFeature()
        }
    )
}

