import SwiftUI
import CoreInterfaces
import ComposableArchitecture

@main
struct iOSApp: App {
    let store = Store(initialState: AppCoordinator.State()) {
        AppCoordinator()
    }
    
	var body: some Scene {
		WindowGroup {
            ContentView(store: store)
		}
	}
}
