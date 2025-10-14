//
//  IssueDetailView.swift
//  Issues
//
//  Created by Federico Torres on 13/10/25.
//

import ComposableArchitecture
import CoreInterfaces
import SwiftUI

public struct IssueDetailView: View {
    @Bindable var store: StoreOf<IssueDetailFeature>
    
    public init(store: StoreOf<IssueDetailFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Group {
            if store.isLoading {
                ProgressView("Loading issue details...")
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
            } else if let issue = store.issueDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Title Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text(issue.title)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            HStack(spacing: 12) {
                                StatusBadge(status: issue.status)
                                PriorityBadge(priority: issue.priority)
                            }
                        }
                        
                        Divider()
                        
                        // Description Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Description")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(issue.description)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        
                        Divider()
                        
                        // People Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("People")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            IssueDetailRow(label: "Assignee", value: issue.assignee, icon: "person.fill")
                            IssueDetailRow(label: "Reporter", value: issue.reporter, icon: "person.crop.circle")
                        }
                        
                        Divider()
                        
                        // Dates Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Timeline")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            IssueDetailRow(label: "Created", value: issue.createdDate, icon: "calendar.badge.plus")
                            IssueDetailRow(label: "Due Date", value: issue.dueDate, icon: "calendar.badge.clock")
                        }
                    }
                    .padding()
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "doc.questionmark")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No Issue Details")
                        .font(.headline)
                    Text("Unable to load issue information")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .navigationTitle("Issue Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

struct IssueDetailRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
    }
}

struct StatusBadge: View {
    let status: String
    
    var backgroundColor: Color {
        switch status.lowercased() {
        case "open": return .blue
        case "in progress": return .orange
        case "closed": return .green
        default: return .gray
        }
    }
    
    var body: some View {
        Text(status)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(backgroundColor.opacity(0.2))
            .foregroundColor(backgroundColor)
            .cornerRadius(8)
    }
}

struct PriorityBadge: View {
    let priority: String
    
    var backgroundColor: Color {
        switch priority.lowercased() {
        case "high": return .red
        case "medium": return .orange
        case "low": return .green
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.caption2)
            Text(priority)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(backgroundColor.opacity(0.2))
        .foregroundColor(backgroundColor)
        .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        IssueDetailView(
            store: Store(
                initialState: IssueDetailFeature.State(
                    issueId: "1",
                    issueDetail: IssueDetailUIModel(
                        id: "1",
                        title: "Critical Bug in Authentication",
                        description: "Users are unable to login with their credentials. The issue appears to be related to the OAuth token refresh mechanism.",
                        status: "Open",
                        assignee: "John Doe",
                        priority: "High",
                        createdDate: "2024-10-01",
                        dueDate: "2024-10-15",
                        reporter: "Jane Smith"
                    )
                )
            ) {
                IssueDetailFeature()
            }
        )
    }
}

