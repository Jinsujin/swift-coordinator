import SwiftUI

enum Tab {
    case one
    case two
    case three
}

struct ContentView: View {
    var body: some View {
        TabHomeView()
    }
}

struct ADetail: View {
    @StateObject var coordinator = Coordinator()
    
    // SwiftUI 에서 NavigationLink 는 View 내부에 위치해야 한다
    // => 현재 View 에서 화면을 이동시켜야 한다
    var body: some View {
        NavigationView {
            coordinator.navigationLink()
        }.onAppear { coordinator.push(.mintView) }
    }
}

struct TabHomeView: View {
    @State private var currentTab: Tab = .one
    
    var body: some View {
        TabView(selection: $currentTab) {
            ADetail()
                .tabItem{ Text("One") }
                .tag(Tab.one)
            
            Text("Two")
                .tabItem{ Text("Two") }
                .tag(Tab.two)
            
            Text("Three")
                .tabItem{ Text("Three") }
                .tag(Tab.three)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
