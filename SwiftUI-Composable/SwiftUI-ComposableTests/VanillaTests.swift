import XCTest
@testable import SwiftUI_Composable

final class VanillaTests: XCTestCase {

    func testFirstModel() {
        let model = FirstTabModel()
        
        let expectation = expectation(description: "goInventoryTab")
        model.goInventoryTab = {
            expectation.fulfill()
        }
        model.goInventoryButtonTapped()
        wait(for: [expectation], timeout: 0)
    }
    
    func testAppModel() {
        let model = AppModel(firstTab: FirstTabModel())
        model.firstTab.goInventoryButtonTapped()
        XCTAssertEqual(model.selectedTab, .two)
    }
}
