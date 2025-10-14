import Assets
import CoreInterfaces
import ComposableArchitecture
import Issues
import SwiftUI
import shared

struct ContentView: View {
    @Bindable var store: StoreOf<AppCoordinator>
    
    init(store: StoreOf<AppCoordinator>) {
        self.store = store
    }
    
	var body: some View {
        NavigationStack(
            path: $store.scope(
                state: \.path,
                action: \.path
            )
        ) {
            AssetsListView(
                store: store.scope(
                    state: \.assetsList,
                    action: \.assetsList
                )
            )
        } destination: { store in
            switch store.case {
            case let .assetDetail(assetDetailStore):
                AssetDetailView(store: assetDetailStore)
            case let .issuesListPicker(issuesStore):
                IssuesListPickerView(
                    store: issuesStore,
                    onIssueSelected: { _ in }
                )
            }
        }
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
        ContentView(
            store: Store(initialState: AppCoordinator.State()) {
                AppCoordinator()
            }
        )
	}
}
