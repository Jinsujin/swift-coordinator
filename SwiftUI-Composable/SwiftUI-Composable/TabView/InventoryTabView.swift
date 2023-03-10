import ComposableArchitecture
import SwiftUI

struct InventoryTabFeature: ReducerProtocol {
    struct State: Equatable {
        var items: IdentifiedArrayOf<Item> = []
        
    }
    enum Action: Equatable {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        
    }
}

struct InventoryTabView: View {
    let store: StoreOf<InventoryTabFeature>
    
    var body: some View {
        WithViewStore(
            self.store, observe: \.items
        ) { viewStore in
            List {
                ForEach(viewStore.state) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                            
                            switch item.status {
                            case let .inStock(quantity):
                                Text("In stock: \(quantity)")
                            case let .outOfStock(isOnBackOrder):
                                Text( "Out of stock \(isOnBackOrder ? ": on back order" : "")"
                                )
                            }
                        }
                        
                        Spacer()
                        
                        if let color = item.color {
                            Rectangle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(color.swiftUIColor)
                                .border(Color.black, width: 1)
                        }
                        
                        Button {
                            // …
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                        .padding(.leading)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(
                        item.status.isInStock ? nil : Color.gray
                    )
                }
            }
        }
    }
}

struct Inventory_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      InventoryTabView(
        store: Store(
          initialState: InventoryTabFeature.State(
            items: [
              .headphones,
              .mouse,
              .keyboard,
              .monitor,
            ]
          ),
          reducer: InventoryTabFeature()
        )
      )
    }
  }
}
