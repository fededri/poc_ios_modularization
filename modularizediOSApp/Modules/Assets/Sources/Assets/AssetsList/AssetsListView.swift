//
//  AssetsListView.swift
//  Assets
//
//  Created by Federico Torres on 11/10/25.
//

import ComposableArchitecture
import CoreInterfaces
import SwiftUI

public struct AssetsListView: View {
    @Bindable var store: StoreOf<AssetsListFeature>
    
    public init(store: StoreOf<AssetsListFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Group {
            if store.isLoading && store.assets.isEmpty {
                ProgressView("Loading assets...")
            } else if let errorMessage = store.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    Text("Error")
                        .font(.headline)
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else if store.assets.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No Assets")
                        .font(.headline)
                    Text("There are no assets to display")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
            } else {
                List(store.assets) { asset in
                    Button(action: {
                        store.send(.assetTapped(id: asset.id))
                    }) {
                        AssetRowView(asset: asset)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(ListRowButtonStyle())
                }
            }
        }
        .navigationTitle("Assets")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    store.send(.filtersTapped)
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .sheet(
            item: $store.scope(state: \.destination?.filters, action: \.destination.filters)
        ) { store in
            AssetFiltersView(store: store)
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

struct AssetRowView: View {
    let asset: AssetUIModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(asset.id)
                .font(.headline)
            
            HStack {
                Text("Status:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(asset.status)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            
            HStack {
                Text("Category:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(asset.category.name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ListRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed 
                    ? Color.gray.opacity(0.2)
                    : Color.clear
            )
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    NavigationStack {
        AssetsListView(
            store: Store(
                initialState: AssetsListFeature.State(
                    assets: [
                        AssetUIModel(
                            id: "Asset 1",
                            status: "Active",
                            category: AssetCategoryType(id: "1", name: "Equipment")
                        ),
                        AssetUIModel(
                            id: "Asset 2",
                            status: "Inactive",
                            category: AssetCategoryType(id: "2", name: "Furniture")
                        ),
                        AssetUIModel(
                            id: "Asset 3",
                            status: "Active",
                            category: AssetCategoryType(id: "1", name: "Equipment")
                        )
                    ]
                )
            ) {
                AssetsListFeature()
            }
        )
    }
}

