import ComposableArchitecture
import SwiftUI
import SwiftUINavigation

enum AlertAction<Action> {
    case dismiss
    case presented(Action)
}

extension AlertAction: Equatable where Action: Equatable {}

extension View {
    func alert<Action>(
        store: Store<AlertState<Action>?, AlertAction<Action>>
    ) -> some View {
        WithViewStore(store, observe: { $0 }, removeDuplicates: { ($0 != nil) == ($1 != nil) }) { viewStore in
            self.alert(
                unwrapping: Binding( //viewStore.binding(send: .dismiss)
                    get: {viewStore.state},
                    set: { newState in
                        viewStore.send(.dismiss)
                    }
                )
            ) { action in
                if let action {
                    viewStore.send(.presented(action))
                }
            }
        }
    }
}


//extension Reducer {
//    func alert<AlertAction>(
//        state alertKeyPath: WritableKeyPath<State, AlertState<AlertAction>?>,
//        action alertCasePath: CasePath<Action, AlertAction>
//
//    ) -> some ReducerOf<Self> {
//        Reduce { state, action in
//            self.reduce(into: &state, action: action)
//            if alertCasePath ~= action {
//                state[keyPath: alertKeyPath] = nil
//            }
//            return effects
//        }
//    }
//}
