import SwiftUI
import ComposableArchitecture

@main
struct SwiftUI_ComposableApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                initialState: AppFeature.State(
                    selectedTab: .two,
                    inventoryTab: InventoryTabFeature.State(
                        addItem: ItemFormFeature.State(
                            item: Item(name: "Macbook", status: .inStock(quantity: 100))
                        ),
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
