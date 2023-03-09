import SwiftUI
import ComposableArchitecture

struct AppFeature: ReducerProtocol {
    struct State: Equatable {
        var selectedTab: Tab = .one
        var firstTab = FirstTabFeature.State()
        var inventoryTab = InventoryTabFeature.State()
        var thirdTab = ThirdTabFeature.State()
    }
    
    enum Action: Equatable {
        case selectedTabChanged(Tab)
        case firstTab(FirstTabFeature.Action)
        case inventoryTab(InventoryTabFeature.Action)
        case thirdTab(ThirdTabFeature.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .selectedTabChanged(tab):
                state.selectedTab = tab
                return .none
                
            // 수정 전: 하위뷰의 이벤트를 바로 받아온다
//            case .firstTab(.goInventoryButtonTapped):
//                state.selectedTab = .two
//                return .none
                
            // 수정 후: Delegate Action 을 사용해 하위뷰와 커뮤니케이션한다
            case let .firstTab(.delegate(action)):
                switch action {
                case .switchToInventoryTab:
                    state.selectedTab = .two
                    return .none
                }
                
            case .firstTab, .inventoryTab, .thirdTab:
                return .none
            }
        }
//    state: CasePath<ParentState, ChildState>
//    action: CasePath<ParentAction, ChildAction> // CasePath(Action.firstTab)
        Scope(state: \.firstTab, action: /Action.firstTab) {
            FirstTabFeature()
        }
        Scope(state: \.inventoryTab, action: /Action.inventoryTab) {
            InventoryTabFeature()
        }
        Scope(state: \.thirdTab, action: /Action.thirdTab) {
            ThirdTabFeature()
        }
    }
    
//    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
//        switch action {
//        case let .selectedTabChanged(tab):
//            state.selectedTab = tab
//            return .none
//        case .firstTab, .inventoryTab, .thirdTab:
//            return .none
//        }
//    }
}


enum Tab {
    case one, two, three
}



struct ContentView: View {
    //    @State var selectedTab: Tab = .one
    
    // StoreOf<AppFeature> == Store<AppFeature.State, AppFeature.Action>
    let store: StoreOf<AppFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: \.selectedTab ) { viewStore in
            
            TabView(selection: viewStore.binding(send: AppFeature.Action.selectedTabChanged)) {

                FirstTabView(
                    store: self.store.scope(
                        state: \.firstTab,
                        action: AppFeature.Action.firstTab
                    )
                )
                .tabItem{ Text("One") }
                .tag(Tab.one)
                
                InventoryTabView(
                    store: self.store.scope(
                        state: \.inventoryTab,
                        action: AppFeature.Action.inventoryTab
                    )
                )
                .tabItem {
                    Text("Two")
                }
                .tag(Tab.two)
                
                ThirdTabView(
                    store: self.store.scope(
                        state: \.thirdTab,
                        action: AppFeature.Action.thirdTab
                    )
                )
                .tabItem {
                    Text("Three")
                }
                .tag(Tab.three)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
            initialState: AppFeature.State(),
            reducer: AppFeature()
            )
        )
    }
}
