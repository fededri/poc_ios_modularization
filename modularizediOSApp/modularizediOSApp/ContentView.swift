import Assets
import SwiftUI
import shared

struct ContentView: View {
    // TODO: implement the navigator
    private let assetsProvider = Assets.AssetsListProvider()

	var body: some View {
        NavigationView {
            assetsProvider.make()
        }
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
