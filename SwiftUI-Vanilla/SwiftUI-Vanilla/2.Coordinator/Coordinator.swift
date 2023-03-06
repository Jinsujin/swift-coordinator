import SwiftUI

enum Destination {
    case mintView
    case pinkView
    case tealView
    case recipeView(Recipe)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .mintView: ColorDetail(color: .mint)
        case .pinkView: ColorDetail(color: .pink)
        case .tealView: ColorDetail(color: .teal)
        case .recipeView(let recipe): RecipeDetailView(recipe: recipe)
        }
    }
}


/// 1. destination update
/// 2. navigationTrigger 속성값(Published)을 업데이트
/// 3. 화면의 view body 재호출 -> 업데이트된 destination 으로 navigation link를 다시 그림
/// 4. navigationLink 의 isActive 가 true 가 되면서 화면전환 발생

final class Coordinator: ObservableObject {
    var destination: Destination = .mintView
    @Published private var navigationTrigger = false
    
    
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
//        navigationTrigger.toggle()
        navigationTrigger = true
    }
    
    private func getTrigger() -> Bool {
        navigationTrigger
    }
    
    private func setTrigger(newValue: Bool) {
        navigationTrigger = newValue
    }
}
