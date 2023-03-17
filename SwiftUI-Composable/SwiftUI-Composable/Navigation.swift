import ComposableArchitecture
import SwiftUI
import SwiftUINavigation

enum AlertAction<Action> {
    case dismiss
    case presented(Action)
}

extension AlertAction: Equatable where Action: Equatable {}

enum ConfirmationDialogAction<Action> {
    case dismiss
    case presented(Action)
}

extension ConfirmationDialogAction: Equatable where Action: Equatable {}

extension View {
    func alert<Action>(
        store: Store<AlertState<Action>?, AlertAction<Action>>
    ) -> some View {
        WithViewStore(
            store,
            observe: { $0 },
            // alert state 가 nil -> non nil 로 변경되거나 그 반대일떄만 수행
            removeDuplicates: { ($0 != nil) == ($1 != nil) }
        ) { viewStore in
            self.alert(
                unwrapping: Binding( //viewStore.binding(send: .dismiss)
                    get: { viewStore.state },
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


extension View {
    func confirmationDialog<Action>(
        store: Store<ConfirmationDialogState<Action>?, ConfirmationDialogAction<Action>>
    ) -> some View {
        WithViewStore(
            store,
            observe: { $0 },
            removeDuplicates: { ($0 != nil) == ($1 != nil) }
        ) { viewStore in
            self.confirmationDialog(
                unwrapping: Binding(
                    get: { viewStore.state },
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


// CasePath: 자식에 대한 작업을 격리
// ifLet 처럼 alert 에 대한 작업을 격리
/**
 - 상위 리듀서를 실행하여 들어오는 모든 작업을 실행할 수 있도록 하는 것이 목적
 - dismiss 를 자동으로 처리하기 위함
 
 
 state:
 - WritableKeyPath<State, AlertState<Action>?>
 - var alert: AlertState<Action.Alert>?
 action:
 - CasePath<Action, AlertAction>
 - case alert(AlertAction<Alert>)
 */

extension ReducerProtocol {
  func alert<Action>(
    state alertKeyPath: WritableKeyPath<State, AlertState<Action>?>,
    action alertCasePath: CasePath<Self.Action, AlertAction<Action>>
  ) -> some ReducerProtocol<State, Self.Action> {
    Reduce { state, action in
      let effects = self.reduce(into: &state, action: action)
// alertCasePath 와 action이 일치하는 경우(AlertAction) 추가 로직을 계층화하여 삭제
// ~= : 범위체크 연산자
      if alertCasePath ~= action {
        state[keyPath: alertKeyPath] = nil
      }
      return effects
    }
  }
}

extension ReducerProtocol {
  func confirmationDialog<Action>(
    state alertKeyPath: WritableKeyPath<State, ConfirmationDialogState<Action>?>,
    action alertCasePath: CasePath<Self.Action, ConfirmationDialogAction<Action>>
  ) -> some ReducerProtocol<State, Self.Action> {
    Reduce { state, action in
      let effects = self.reduce(into: &state, action: action)
      if alertCasePath ~= action {
        state[keyPath: alertKeyPath] = nil
      }
      return effects
    }
  }
}
