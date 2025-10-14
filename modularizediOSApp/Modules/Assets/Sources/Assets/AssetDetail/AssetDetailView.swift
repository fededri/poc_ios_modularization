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
    @Environment(\.navigator) var navigator: (any Navigator)?
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
                        
                        // Linked Issue Section
                        if let linkedIssue = store.linkedIssue {
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Linked Issue")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                LinkedIssueCard(issue: linkedIssue)
                            }
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    store.send(.linkIssueTapped)
                } label: {
                    Label("Link Issue", systemImage: "link.badge.plus")
                }
            }
        }
        .navigationDestination(for: NavigationDestination.self) { destination in
            destinationView(for: destination)
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    @ViewBuilder
    private func destinationView(for destination: NavigationDestination) -> some View {
        navigator?.viewForDestination(destination) { result in
//            store.send(.navigationResult(result))
//            navigationPath.removeLast()
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

// TODO: move to SharedUI
struct LinkedIssueCard: View {
    let issue: IssueUIModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "link.circle.fill")
                    .foregroundColor(.blue)
                Text(issue.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            Text(issue.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack(spacing: 8) {
                Image(systemName: "tag.fill")
                    .font(.caption2)
                    .foregroundColor(statusColor(for: issue.status))
                Text(issue.status)
                    .font(.caption)
                    .foregroundColor(statusColor(for: issue.status))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "open": return .blue
        case "in progress": return .orange
        case "closed": return .green
        default: return .gray
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

