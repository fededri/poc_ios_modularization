import Assets
import CoreInterfaces
import ComposableArchitecture
import SwiftUI
import shared

struct ContentView: View {
    @State private var navigationPath = NavigationPath()
    @State private var navigator: (any Navigator)? = nil  // Starts as nil, set in onAppear
    private let assetsProvider = Assets.AssetsListProvider()
    
	var body: some View {
        NavigationStack(path: $navigationPath) {
            NavigationLink("Start") {
                assetsProvider.make()
            }
        }
        .environment(\.navigator, navigator)
        .onAppear {
            if navigator == nil {
                navigator = PathNavigator(
                    navigationPath: $navigationPath, 
                    viewFactory: AppNavigationViewFactory()
                )
            }
        }
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
