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
    @Environment(\.navigationViewFactory) var navigationViewFactory
    @Bindable var store: StoreOf<AssetsListFeature>
    @State var navigationPath = NavigationPath()
    
    init(store: StoreOf<AssetsListFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $navigationPath) {
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
                        Button {
                            store.send(.assetTapped(id: asset.id))
                        } label: {
                            AssetRowView(asset: asset)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Assets")
            .navigationDestination(for: NavigationDestination.self) { destination in
                destinationView(for: destination)
            }
            .task {
                guard let navigationViewFactory = navigationViewFactory else { return }
                store.send(.setNavigator(PathNavigator(navigationPath: $navigationPath, viewFactory: navigationViewFactory)))
            }
            .navigationDestination(
                item: $store.scope(state: \.destination?.assetDetail, action: \.destination.assetDetail)
            ) { store in
                AssetDetailView(store: store)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    @ViewBuilder
    private func destinationView(for destination: NavigationDestination) -> some View {
        navigationViewFactory?.createView(for: destination)
//        navigator?.viewForDestination(destination) { result in
//            //store.send(.navigationResult(result))
//            navigationPath.removeLast()
//        }
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

#Preview {
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

