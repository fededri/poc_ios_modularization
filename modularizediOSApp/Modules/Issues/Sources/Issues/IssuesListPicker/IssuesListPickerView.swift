//
//  IssuesListPickerView.swift
//  Issues
//
//  Created by Federico Torres on 13/10/25.
//

import ComposableArchitecture
import CoreInterfaces
import SwiftUI

public struct IssuesListPickerView: View {
    @Bindable var store: StoreOf<IssuesListPickerFeature>
    let onIssueSelected: (IssueUIModel) -> Void
    
    public init(
        store: StoreOf<IssuesListPickerFeature>,
        onIssueSelected: @escaping (IssueUIModel) -> Void
    ) {
        self.store = store
        self.onIssueSelected = onIssueSelected
    }
    
    public var body: some View {
        Group {
            if store.isLoading && store.issues.isEmpty {
                ProgressView("Loading issues...")
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
            } else if store.issues.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No Issues")
                        .font(.headline)
                    Text("There are no issues available")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
            } else {
                List(store.issues) { issue in
                    Button {
                        onIssueSelected(issue)
                        store.send(.issueSelected(issue))
                    } label: {
                        IssuePickerRowView(issue: issue)
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing) {
                        Button {
                            store.send(.issueTapped(id: issue.id))
                        } label: {
                            Label("Details", systemImage: "info.circle")
                        }
                        .tint(.blue)
                    }
                }
            }
        }
        .navigationTitle("Select Issue")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    store.send(.cancelTapped)
                }
            }
        }
        .navigationDestination(
            item: $store.scope(state: \.destination?.issueDetail, action: \.destination.issueDetail)
        ) { store in
            IssueDetailView(store: store)
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

struct IssuePickerRowView: View {
    let issue: IssueUIModel
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(issue.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
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
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
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
        IssuesListPickerView(
            store: Store(
                initialState: IssuesListPickerFeature.State(
                    issues: [
                        IssueUIModel(
                            id: "1",
                            title: "Critical Bug",
                            description: "Authentication system failure",
                            status: "Open"
                        ),
                        IssueUIModel(
                            id: "2",
                            title: "Feature Request",
                            description: "Add dark mode support",
                            status: "Closed"
                        ),
                        IssueUIModel(
                            id: "3",
                            title: "Performance Issue",
                            description: "Dashboard loading slowly",
                            status: "In Progress"
                        )
                    ]
                )
            ) {
                IssuesListPickerFeature()
            },
            onIssueSelected: { issue in
                print("Selected: \(issue.title)")
            }
        )
    }
}

