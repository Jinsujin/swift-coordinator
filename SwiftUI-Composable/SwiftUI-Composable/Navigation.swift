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

enum SheetAction<Action> {
    case dismiss
    case presented(Action)
}

extension SheetAction: Equatable where Action: Equatable {}



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
                        if viewStore.state != nil {
                            viewStore.send(.dismiss)
                        }
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

/**
 
 
 */
extension ReducerProtocol {
    func sheet<ChildState, ChildAction>(
        state stateKeyPath: WritableKeyPath<State, ChildState?>,
        action actionCasePath: CasePath<Action, SheetAction<ChildAction>>,
        @ReducerBuilder<ChildState, ChildAction> child: () -> some ReducerProtocol<ChildState, ChildAction>
    ) -> some ReducerProtocolOf<Self> {
        let child = child()
        return Reduce { state, action in
            switch (
                state[keyPath: stateKeyPath], // optional State
                actionCasePath.extract(from: action) // optional Action
            ) {
                
                // sheet 가 아닌 경우
            case (_, .none):
                return self.reduce(into: &state, action: action)
                
                // sheet 이지만, child 가 presented 또는 dismiss일떄
            case (.none, .some(.presented)), (.none, .some(.dismiss)):
                // ChildState 가 없으므로 런타임 경고 발생시킴
                XCTFail("A sheet action was sent while child state was nil.")
                return self.reduce(into: &state, action: action)
                
            case (.some(var childState), .some(.presented(let childAction))):
                // 1. child Reducer 실행
                let childEffects = child.reduce(into: &childState, action: childAction)
                // 2. child State 로 parent state 업뎃
                state[keyPath: stateKeyPath] = childState
                // 3. parent reducer 실행
                let effects = self.reduce(into: &state, action: action)
                // 4. childEffect, parent effect 병합
                return .merge(
                    childEffects.map { actionCasePath.embed(.presented($0)) },
                    effects
                )
                
            case (.some, .some(.dismiss)):
                let effects = self.reduce(into: &state, action: action)
                state[keyPath: stateKeyPath] = nil
                return effects
            }
        }
    }
}

extension View {
    func sheet<ChildState: Identifiable, ChildAction>(
        store: Store<ChildState?, SheetAction<ChildAction>>,
        @ViewBuilder child: @escaping (Store<ChildState, ChildAction>) -> some View
    ) -> some View {
        WithViewStore(store, observe: { $0?.id }) { viewStore in // $0 은 optional child state
            self.sheet(
                item: Binding(
                    get: { viewStore.state.map { Identified($0, id: \.self) } },
                    set: { newState in
                        if viewStore.state != nil {
                            viewStore.send(.dismiss)
                        }
                    }
                )
            ) { _ in
                // addItemID 이 nil 이 아니면 화면을 이동한다
                // 하지만 화면을 만드는데 필요가 없다
                IfLetStore(
                    store.scope(
                        state: returningLastNonNilValue { $0 }, // { $0 }, // \.addItem,
                        action: SheetAction.presented //{ .addItem(.presented($0)) }
                    )
                ) { store in
                    child(store)
                }
            }
        }
    }
}

// sheet 가 움직이는 동안 컨텐츠가 사라지는 현상이 있다. 애니메이션 되는 동안 컨텐츠는 계속 보일 수 있도록 하기 위해
// 마지막 자식 상태 값을 유지하여 항상 뷰에 제공해, sheet 가 dismiss 되더라도 컨텐츠를 표시
func returningLastNonNilValue<A, B>(
    _ f: @escaping (A) -> B?
) -> (A) -> B? {
    var lastValue: B?
    return { a in
        lastValue = f(a) ?? lastValue
        return lastValue
    }
}
