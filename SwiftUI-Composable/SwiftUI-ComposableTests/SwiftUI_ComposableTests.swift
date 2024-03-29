import ComposableArchitecture
import XCTest

@testable import SwiftUI_Composable

/**
 @MainActor 를 붙여줘야 한다!
 
 Error Message:
 The "Store" class is not thread-safe, and so all interactions with an instance of "Store" (including all of its scopes and derived view stores) must be done on the main thread.
 
 */

@MainActor
final class SwiftUI_ComposableTests: XCTestCase {
    
    func testAddItem() async {
        let store = TestStore(
            initialState: InventoryTabFeature.State(),
            reducer: InventoryTabFeature()
        ) {
            $0.uuid = .incrementing
        }
        
        await store.send(.addButtonTapped) {
            $0.addItem = ItemFormFeature.State(
                item: Item(
                    id: UUID(
                        uuidString: "00000000-0000-0000-0000-000000000000"
                    )!,
                    name: "",
                    status: .inStock(quantity: 1)
                )
            )
        }
        
//        await store.send(
//          .addItem(.set(\.$item.name, "Headphones"))
//        ) {
//          $0.addItem?.item.name = "Headphones"
//        }
        
        await store.send(.addItem(.presented(.set(\.$item.name, "Headphones")))) {
            $0.addItem?.item.name = "Headphones"
        }
        
        await store.send(.confirmAddItemButtonTapped) {
            $0.addItem = nil
            $0.items = [
                Item(
                    id: UUID(
                        uuidString: "00000000-0000-0000-0000-000000000000"
                    )!,
                    name: "Headphones",
                    status: .inStock(quantity: 1)
                )
            ]
        }
    }
    
    func testDuplicate() async {
        let item = Item.headphones
        
        let store = TestStore(
            initialState: InventoryTabFeature.State(items: [item]),
            reducer: InventoryTabFeature()
        ) {
            $0.uuid = .incrementing
        }
        // 클로저를 사용해 주입하는 방법을 추천
        //        store.dependencies.uuid = .incrementing
        
        await store.send(.duplicateButtonTapped(id: item.id)) {
            $0.confirmationDialog = .duplicate(item: item)
        }
        
        await store.send(.confirmationDialog(.presented(.confirmDuplication(id: item.id)))) {
            $0.confirmationDialog = nil
            $0.items = [
                // Model 내부에서 UUID() 를 생성하므로 테스트는 무조건 실패
                // => uuid dependency 를 외부에서 제어해서 해결
                //                item.duplicate(),
                Item(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000"),
                    name: "Headphones",
                    color: .blue,
                    status: .inStock(quantity: 20)
                ),
                item
            ]
        }
    }
    
    func testDelete() async {
        let item = Item.headphones
        
        let store = TestStore(
            initialState: InventoryTabFeature.State(items: [item]),
            reducer: InventoryTabFeature()
        )
        
        await store.send(.deleteButtonTapped(id: item.id)) {
            $0.alert = .delete(item: item)
        }
        
        //        await store.send(.alert(.presented(.confirmDeletion(id: item.id)))) {
        //            $0.items = []
        //        }
        //
        //        await store.send(.alert(.dismiss)) {
        //            $0.alert = nil
        //        }
        
        await store.send(.alert(.presented(.confirmDeletion(id: item.id)))) {
            $0.items = []
            $0.alert = nil
        }
    }
    
    func testGotoInventory() async {
        // 테스트하기 위해 State 에 Equatable을 채택해야 한다
        let store = TestStore(
            initialState: AppFeature.State(),
            reducer: AppFeature()
        )
        
        // NOTE: - 테스트방법1. 액션을 실행하고 클로저 안에서 값 검사
        //        await store.send(.firstTab(.goInventoryButtonTapped)) {
        //            // 액션 실행 후에 들어온다
        ////            −   selectedTab: .one,
        ////            +   selectedTab: .two,
        //            $0.selectedTab = .two
        //        }
        
        //        await store.receive(.firstTab(.delegate(.switchToInventoryTab)))
        
        
        // NOTE: - 테스트방법2. Action 을 실행하고, 결과를 받았을때(receive) assert 로 값 검증
        //        await store.send(.firstTab(.goInventoryButtonTapped))
        //        await store.receive {
        ////            guard case .firstTab(.delegate(.switchToInventoryTab)) = $0 else {
        ////                return false
        ////            }
        //            guard case .firstTab(.delegate) = $0 else { return false }
        //            // match 하는 경우
        //            return true
        //        } assert: {
        //            $0.selectedTab = .two
        //        }
        
        // NOTE: - 테스트방법3. Case Path 를 사용해 위 코드를 아래처럼 줄일 수 있다
        //        await store.send(.firstTab(.goInventoryButtonTapped))
        //        await store.receive(
        //            (/AppFeature.Action.firstTab).appending(path: /FirstTabFeature.Action.delegate)
        //        ) {
        //            $0.selectedTab = .two
        //        }
        
        // NOTE: - 테스트방법4. Action 이 Equatable 을 채택해야 함
        await store.send(.firstTab(.goInventoryButtonTapped))
        await store.receive(.firstTab(.delegate(.switchToInventoryTab))) {
            $0.selectedTab = .two
        }
    }
}
