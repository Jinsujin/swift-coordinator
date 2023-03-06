import SwiftUI
import Combine

/**
[화면 전환이 일어나는 흐름]
 1. destination update
 2. navigationTrigger 속성값(Published)을 업데이트
 3. 화면의 view body 재호출 -> 업데이트된 destination 으로 navigation link를 다시 그림
 4. navigationLink 의 isActive 가 true 가 되면서 화면전환 발생
 
 [참고]
 https://labs.brandi.co.kr//2022/12/12/leehs81.html
 */


/// NavigationView 기반에서 Coordinator
/// - NavigationLink 를 사용해 화면을 이동해야 하는데, 이는 View 에 종속이 되므로 현재 화면에서 이동로직을 구현해야하는 제약이 생김
/// - 참고:
/// iOS 16 이후로 NavigationView  를 대체하는 NavigationStack 이 나타남
/// => 해당 코디네이터도 변경이 필요
final class Coordinator: ObservableObject {
    var destination: Destination = .mintView
    @Published private var navigationTrigger = false
    @Published private var rootNavigationTrigger = false
    
    private let isRoot: Bool
    private var cancellable: Set<AnyCancellable> = []
    
    init(isRoot: Bool = false) {
        self.isRoot = isRoot
        
        // root 일때만 구독하도록 한다
        if isRoot {
            NotificationCenter.default.publisher(for: .popToRoot)
                .sink { [unowned self] _ in
                    rootNavigationTrigger = false
                }
                .store(in: &cancellable)
        }
    }
    
    func navigationLink() -> some View {
        NavigationLink(isActive: Binding<Bool>(get: getTrigger ,set: setTrigger)) {
            destination.view
        } label: {
            // 화면에 아무것도 보이지 않는 뷰를 사용해
            // 모든 뷰의 NavigationLink를 작성
            // 링크가 화면에 보이지않음 => 사용자 액션으로 동작할수 없다
            EmptyView()
        }
    }
    
    func push(_ destination: Destination) {
        self.destination = destination
        if isRoot {
            rootNavigationTrigger.toggle()
        } else {
            navigationTrigger.toggle()
        }
    }
    
    func popToRoot() {
        NotificationCenter.default.post(name: .popToRoot, object: nil)
    }
    
    private func getTrigger() -> Bool {
        isRoot ? rootNavigationTrigger : navigationTrigger
    }
    
    private func setTrigger(newValue: Bool) {
        if isRoot {
            rootNavigationTrigger = newValue
        } else {
            navigationTrigger = newValue
        }
    }
}

// MARK: - extension Notification 
extension Notification.Name {
    static let popToRoot = Notification.Name("PopToRoot")
}
