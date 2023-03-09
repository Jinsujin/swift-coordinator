import SwiftUI
import XCTestDynamicOverlay

class AppModel: ObservableObject {
    // model 이 변경될때마다 bind 를 다시해준다
    @Published var firstTab: FirstTabModel {
        didSet { self.bind() }
    }
    @Published var selectedTab: Tab
    
    init(
        firstTab: FirstTabModel,
        selectedTab: Tab = .one
    ) {
        self.firstTab = firstTab
        self.selectedTab = selectedTab
        self.bind()
    }
    
    private func bind() {
        self.firstTab.goInventoryTab = { [weak self] in
            // ex) 서버 리퀘스트 같은 작업 실행
            self?.selectedTab = .two
        }
    }
}

class FirstTabModel: ObservableObject {
    // 구현하지 않으면 알려준다. 기능상 반드시 구현해야 하는 클로저에 사용
    var goInventoryTab: () -> Void = unimplemented("FirstTabModel.goInventoryTab")
    
    func goInventoryButtonTapped() {
        self.goInventoryTab()
    }
}
