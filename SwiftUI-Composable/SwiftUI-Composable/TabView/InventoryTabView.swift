import ComposableArchitecture
import SwiftUI

struct InventoryTabFeature: ReducerProtocol {
    struct State: Equatable {
        var alert: AlertState<Action.Alert>?
        var items: IdentifiedArrayOf<Item> = []
        var confirmationDialog: ConfirmationDialogState<Action.Dialog>?
    }
    
    enum Action: Equatable {
        case alert(AlertAction<Alert>)
        case deleteButtonTapped(id: Item.ID)
        case duplicateButtonTapped(id: Item.ID)
        case confirmationDialog(ConfirmationDialogAction<Dialog>)
        
        enum Dialog: Equatable {
            case confirmDuplication(id: Item.ID)
        }
        enum Alert: Equatable {
            case confirmDeletion(id: Item.ID)
            
            // AlertAction 을 정의하고 view extension 에서 dismiss 를 처리함으로써 필요가 없어짐
//            case dismiss
        }
    }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                
            case let .confirmationDialog(.presented(.confirmDuplication(id: id))):
                guard let item = state.items[id: id],
                      let index = state.items.index(id: id) else {
                    return .none
                }
                state.items.insert(item.duplicate(), at: index)
                return .none
                
            case .confirmationDialog(.dismiss):
                return .none
                
            case let .duplicateButtonTapped(id):
                guard let item = state.items[id: id] else { return .none }
                state.confirmationDialog = .duplicate(item: item)
                return .none
                
            case let .alert(.presented(.confirmDeletion(id: id))):
                state.items.remove(id: id)
                return .none
                
            case let .deleteButtonTapped(id):
                guard let item = state.items[id: id] else {
                    return .none
                }
                // alert 창을 보여준다
                state.alert = .delete(item: item)
                return .none
                
            case .alert:
                return .none
                
// .alert(state: \.alert, action: /Action.alert) 를 구현함으로써
// state 를 수동으로 nil 을 할당할 필요가 없어짐
//            case .alert(.dismiss):
//                state.alert = nil
//                return .none

            }
        }
        .alert(state: \.alert, action: /Action.alert)
        .confirmationDialog(state: \.confirmationDialog, action: /Action.confirmationDialog)
    }
}

/// 테스트에서도 재사용하기 위해 분리
extension AlertState where Action == InventoryTabFeature.Action.Alert {
    static func delete(item: Item) -> Self {
        AlertState {
            TextState(#"Delete "\#(item.name)""#)
        } actions: {
            ButtonState(role: .destructive, action: .send(.confirmDeletion(id: item.id), animation: .default)) {
                TextState("Delete")
            }
        } message: {
            TextState("정말 삭제하시겠어요?")
        }
    }
}

extension ConfirmationDialogState where Action == InventoryTabFeature.Action.Dialog {
    static func duplicate(item: Item) -> Self {
        ConfirmationDialogState {
            TextState(#"Duplicate "\#(item.name)""#)
        } actions: {
            ButtonState(action: .send(.confirmDuplication(id: item.id), animation: .default)) {
                TextState("Duplicate")
            }
        } message: {
            TextState("복사 하시겠어요?")
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
                        
                        HStack {
                            Button {
                                viewStore.send(.duplicateButtonTapped(id: item.id))
                            } label: {
                                Image(systemName: "doc.on.doc.fill")
                            }
                            
                            Button {
                                viewStore.send(.deleteButtonTapped(id: item.id))
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                        }
                        .padding(.leading)
                        
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(
                        item.status.isInStock ? nil : Color.gray
                    )
                }
            }
            .alert(store:
                    self.store.scope(
                        state: \.alert,
                        action: InventoryTabFeature.Action.alert)
            )
            .confirmationDialog(store: self.store.scope(
                state: \.confirmationDialog,
                action: InventoryTabFeature.Action.confirmationDialog)
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
