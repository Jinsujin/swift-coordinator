import SwiftUI

struct ColorDetail: View {
    var color: Color

    var body: some View {
        color.navigationTitle(color.description)
    }
}

struct BasicNavigationView: View {

    var body: some View {
        // 사람들은 navigation link 를 탭해서 NavigationStack 또는 NavigationSplitView 에 View 를 표시한다.
        
        // 1. Label 을 사용하여 link 를 표시
//        NavigationLink { // Destination
//            ADetail()
//        } label: {
//            Label("Work Folder", systemImage: "folder")
//        }
        
        // 2. String 을 사용한 convenience initializer
//        NavigationLink("Work Folder") {
//            ADetail()
//        }
        
        // 3.
        NavigationStack {
            List {
                NavigationLink("Mint", value: Color.mint)
                NavigationLink("Pink", value: Color.pink)
                NavigationLink("Teal", value: Color.teal)
            }
            .navigationDestination(for: Color.self) { color in
                ColorDetail(color: color)
            }
            .navigationTitle("Colors")
        }
    }
}

struct BasicNavigation_Previews: PreviewProvider {
    static var previews: some View {
        BasicNavigationView()
    }
}
