import SwiftUI

struct ViewA: View {
    @StateObject var coordinator = Coordinator()
    
    // SwiftUI 에서 NavigationLink 는 View 내부에 위치해야 한다
    // => 현재 View 에서 화면을 이동시켜야 한다
    var body: some View {
        NavigationView {
            coordinator.navigationLink()
        }.onAppear { coordinator.push(.mintView) }
    }
}

struct ViewA_Previews: PreviewProvider {
    static var previews: some View {
        ViewA()
    }
}
