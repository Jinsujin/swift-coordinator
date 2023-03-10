import ComposableArchitecture
import SwiftUI

struct InventoryTabFeature: ReducerProtocol {
    struct State: Equatable {
        var alert: AlertState<Action.Alert>?
        var items: IdentifiedArrayOf<Item> = []
        
    }
    enum Action: Equatable {
        case alert(Alert)
        case deleteButtonTapped(id: Item.ID)
        
        enum Alert: Equatable {
            case confirmDeletion(id: Item.ID)
            case dismiss
        }
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .alert(.confirmDeletion(id: id)):
            state.items.remove(id: id)
            return .none
            
        case .alert(.dismiss):
            state.alert = nil
            return .none
            
        case let .deleteButtonTapped(id):
            guard let item = state.items[id: id] else {
                return .none
            }
                    
            state.alert = AlertState {
                TextState(#"Delete "\#(item.name)""#)
            } actions: {
//                    ButtonState(role: .destructive, action: .confirmDeletion(id: item.id)) {
//                        TextState("Delete")
//                    }
                
                // animation 을 줄 수 있다
                ButtonState(role: .destructive, action: .send(.confirmDeletion(id: item.id), animation: .default)) {
                    TextState("Delete")
                }
            } message: {
                TextState("정말 삭제하시겠어요?")
            }
            return .none
        }
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
                            viewStore.send(.deleteButtonTapped(id: item.id))
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
            .alert(
                self.store.scope(state: \.alert, action: InventoryTabFeature.Action.alert),
                dismiss: .dismiss
            )
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
