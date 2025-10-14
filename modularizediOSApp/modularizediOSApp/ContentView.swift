import Assets
import CoreInterfaces
import ComposableArchitecture
import SwiftUI
import shared

struct ContentView: View {
    private let assetsProvider = Assets.AssetsListProvider()
    private let navigationViewFactory = AppNavigationViewFactory()
    
	var body: some View {
//        NavigationStack {
//            NavigationLink("Start") {
//                assetsProvider.make()
//            }
//        }
        assetsProvider.make()
        .environment(\.navigationViewFactory, navigationViewFactory)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
