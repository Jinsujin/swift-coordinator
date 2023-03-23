import ComposableArchitecture
import SwiftUI

struct InventoryTabFeature: ReducerProtocol {
    struct State: Equatable {
        var addItem: ItemFormFeature.State?
        var alert: AlertState<Action.Alert>?
        var items: IdentifiedArrayOf<Item> = []
        var confirmationDialog: ConfirmationDialogState<Action.Dialog>?
    }
    
    enum Action: Equatable {
        case cancelAddItemButtonTapped
        case confirmAddItemButtonTapped
        case addButtonTapped
        case addItem(SheetAction<ItemFormFeature.Action>)
//        case dismissAddItem
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
                
            // Sheet Reducer 에서 처리함으로써 필요없게 됨
//            case .addItem(.dismiss):
//                state.addItem = nil
//                return .none
                
            case .addItem:
                return .none
                
                // ifLet 을 사용해 아래코드를 대체할 수 있음
//            case let .addItem(action):
//                guard var itemFormState = state.addItem else { return .none }
//                let itemFormEffects = ItemFormFeature().reduce(into: &itemFormState, action: action)
//                state.addItem = itemFormState
//                return itemFormEffects.map(Action.addItem)
                
                
            case .cancelAddItemButtonTapped:
                state.addItem = nil
                return .none
                
            case .confirmAddItemButtonTapped:
                defer { state.addItem = nil }
                guard let item = state.addItem?.item else { return .none }
                state.items.append(item)
                return .none
                

            case .addButtonTapped:
                state.addItem = ItemFormFeature.State(
                    item: Item(name: "", status: .inStock(quantity: 1))
                )
                return .none
                
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
        
        .sheet(state: \.addItem, action: /Action.addItem) {
            ItemFormFeature()
        }
        
//        .ifLet(
//            \.addItem,
//             action: (/Action.addItem).appending(path: /SheetAction.presented)
//        ) {
//            ItemFormFeature()
//        }
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
    
    struct ViewState: Equatable {
        // sheet 안의 내용이 바뀌는것에는 관심없다. sheet 에 영향을 주는것은 오로지 ID 이고, 이는 화면을 다시그리는데 필요한 값
        let addItemID: Item.ID? //ItemFormFeature.State?
        let items: IdentifiedArrayOf<Item>
        
        init(state: InventoryTabFeature.State) {
            self.addItemID = state.addItem?.item.id
            self.items = state.items
        }
    }
    
    var body: some View {
        WithViewStore(
            self.store, observe: ViewState.init
        ) { (viewStore: ViewStore<ViewState, InventoryTabFeature.Action>) in
            // preview 에러발생으로 viewStore 의 타입을 명시해줌
            List {
                ForEach(viewStore.items) { item in
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
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add") {
                        viewStore.send(.addButtonTapped)
                        // addButtonTapped Action 이 다시보내짐으로써 새로운 ID 가 생성되기 때문에 화면이 닫혔다가 다시 보여진다
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            viewStore.send(.addButtonTapped)
//                        }
                    }
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
            .sheet(store: self.store.scope(
                state: \.addItem,
                action: InventoryTabFeature.Action.addItem)
            ) { store in
                NavigationStack {
                    ItemFormView(store: store)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    viewStore.send(.cancelAddItemButtonTapped)
                                }
                            }
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Confirm") {
                                    viewStore.send(.confirmAddItemButtonTapped)
                                }
                            }
                        }.navigationTitle("New Item")
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
