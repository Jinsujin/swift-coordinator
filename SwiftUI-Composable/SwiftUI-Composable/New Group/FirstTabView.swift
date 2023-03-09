import ComposableArchitecture
import SwiftUI

struct FirstTabFeature: ReducerProtocol {
    struct State: Equatable {}
    
    enum Action: Equatable {
        case goInventoryButtonTapped
        case delegate(Delegate)
    }
    
    enum Delegate {
        case switchToInventoryTab
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .delegate:
            return .none
            
        case .goInventoryButtonTapped:
            return .send(.delegate(.switchToInventoryTab))
        }
    }
}

struct FirstTabView: View {
    let store: StoreOf<FirstTabFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Button {
                viewStore.send(.goInventoryButtonTapped)
            } label: {
                Text("go inventory")
            }
        }
    }
}

//struct FirstTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        FirstTabView()
//    }
//}
