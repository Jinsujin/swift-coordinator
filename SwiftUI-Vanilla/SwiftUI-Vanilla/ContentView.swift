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

struct TabHomeView: View {
    @State private var currentTab: Tab = .one
    
    var body: some View {
        TabView(selection: $currentTab) {
            ViewA()
                .tabItem{ Text("One") }
                .tag(Tab.one)
            
            ViewB()
                .tabItem{ Text("Two") }
                .tag(Tab.two)
            
            RecipeListView()
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
