//
//  AssetDetailView.swift
//  Assets
//
//  Created by Federico Torres on 13/10/25.
//

import ComposableArchitecture
import CoreInterfaces
import SwiftUI

struct AssetDetailView: View {
    @Bindable var store: StoreOf<AssetDetailFeature>
    
    init(store: StoreOf<AssetDetailFeature>) {
        self.store = store
    }
    
    var body: some View {
        Group {
            if store.isLoading {
                ProgressView("Loading asset details...")
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
            } else if let asset = store.assetDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Basic Information Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Basic Information")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            DetailRow(label: "ID", value: asset.id)
                            DetailRow(label: "Name", value: asset.name)
                            DetailRow(label: "Status", value: asset.status)
                            DetailRow(label: "Category", value: asset.category.name)
                        }
                        
                        Divider()
                        
                        // Description Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Description")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(asset.description)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        
                        Divider()
                        
                        // Details Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Details")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            DetailRow(label: "Location", value: asset.location)
                            DetailRow(label: "Purchase Date", value: asset.purchaseDate)
                            DetailRow(label: "Value", value: asset.value)
                            DetailRow(label: "Manufacturer", value: asset.manufacturer)
                            DetailRow(label: "Serial Number", value: asset.serialNumber)
                        }
                    }
                    .padding()
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "doc.questionmark")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No Asset Details")
                        .font(.headline)
                    Text("Unable to load asset information")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .navigationTitle("Asset Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(label + ":")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .frame(width: 120, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    NavigationStack {
        AssetDetailView(
            store: Store(
                initialState: AssetDetailFeature.State(
                    assetId: "1",
                    assetDetail: AssetDetailUIModel(
                        id: "1",
                        name: "Industrial Equipment",
                        status: "Active",
                        category: AssetCategoryType(id: "1", name: "Equipment"),
                        description: "High-performance industrial equipment for manufacturing operations",
                        location: "Building A, Floor 2, Room 205",
                        purchaseDate: "2023-01-15",
                        value: "$25,000.00",
                        manufacturer: "TechCorp Industries",
                        serialNumber: "TC-2023-001-XYZ"
                    )
                )
            ) {
                AssetDetailFeature()
            }
        )
    }
}

