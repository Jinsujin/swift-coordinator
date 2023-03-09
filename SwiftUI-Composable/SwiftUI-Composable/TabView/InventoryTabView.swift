import ComposableArchitecture
import SwiftUI

struct InventoryTabFeature: ReducerProtocol {
    struct State: Equatable {}
    enum Action: Equatable {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        
    }
}

struct InventoryTabView: View {
    let store: StoreOf<InventoryTabFeature>
    
    var body: some View {
        Text("Inventory")
    }
}
