import Assets
import CoreInterfaces
import ComposableArchitecture
import Issues
import SwiftUI

struct ContentView: View {
    @State private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            AssetsListViewWrapper(
                assetsNavigation: coordinator.assetsNavigation
            )
            .navigationDestination(for: Destination.self) { destination in
                destinationView(for: destination)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for destination: Destination) -> some View {
        switch destination {
        case .assetDetail(let assetId):
            AssetDetailViewWrapper(
                assetId: assetId,
                assetsNavigation: coordinator.assetsNavigation,
                selectedIssue: coordinator.selectedIssueForAsset
            )
        case .issuesListPicker:
            IssuesListPickerViewWrapper(
                issuesNavigation: coordinator.issuesNavigation
            )
        }
    }
}

/// Wrapper for AssetsListView that bridges TCA actions to Combine publishers
struct AssetsListViewWrapper: View {
    let assetsNavigation: AssetsNavigation
    
    var body: some View {
        AssetsListView(
            store: Store(initialState: AssetsListFeature.State()) {
                AssetsListFeature()
                    .observeActions { action in
                        switch action {
                        case .assetTapped(let id):
                            assetsNavigation.publisher.send(.assetTapped(id: id))
                        default:
                            break
                        }
                    }
            }
        )
    }
}

/// Wrapper for AssetDetailView that bridges TCA actions to Combine publishers
struct AssetDetailViewWrapper: View {
    let assetId: String
    let assetsNavigation: AssetsNavigation
    let selectedIssue: IssueUIModel?
    
    var body: some View {
        AssetDetailView(
            store: Store(
                initialState: AssetDetailFeature.State(
                    assetId: assetId,
                    linkedIssue: selectedIssue
                )
            ) {
                AssetDetailFeature()
                    .observeActions { action in
                        switch action {
                        case .linkIssueTapped:
                            assetsNavigation.publisher.send(.linkIssueTapped)
                        default:
                            break
                        }
                    }
            }
        )
    }
}

/// Wrapper for IssuesListPickerView that bridges TCA to Combine publishers
struct IssuesListPickerViewWrapper: View {
    let issuesNavigation: IssuesNavigation
    
    var body: some View {
        IssuesListPickerView(
            store: Store(initialState: IssuesListPickerFeature.State()) {
                IssuesListPickerFeature()
                    .observeActions { action in
                        switch action {
                        case .issueSelected(let issue):
                            issuesNavigation.publisher.send(.issueSelected(issue))
                        case .cancelTapped:
                            issuesNavigation.publisher.send(.cancelTapped)
                        default:
                            break
                        }
                    }
            },
            onIssueSelected: { issue in
                // This callback is also called, but we're handling it via action observation
            }
        )
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    issuesNavigation.publisher.send(.cancelTapped)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
