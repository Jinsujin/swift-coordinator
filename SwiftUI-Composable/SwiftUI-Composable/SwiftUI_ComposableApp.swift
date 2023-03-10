import SwiftUI
import ComposableArchitecture

@main
struct SwiftUI_ComposableApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                initialState: AppFeature.State(
                    inventoryTab: InventoryTabFeature.State(
                        items: [
                            .monitor,
                            .mouse,
                            .keyboard,
                            .headphones
                        ]
                    )
                ),
                reducer: AppFeature()._printChanges()
                )
            )
        }
    }
}
