import SwiftUI

struct ViewA: View {
    @StateObject var coordinator = Coordinator(isRoot: true)
    
    // SwiftUI 에서 NavigationLink 는 View 내부에 위치해야 한다
    // => 현재 View 에서 화면을 이동시켜야 한다
    var body: some View {
        NavigationView {
            LazyVStack {
                coordinator.navigationLink()
                Text("ViewA")
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        coordinator.push(.mintView)
                    } label: {
                        Text("mint")
                    }
                }
                
                ToolbarItem {
                    Button {
                        coordinator.push(.pinkView)
                    } label: {
                        Text("pink")
                    }
                }

                ToolbarItem {
                    Button {
                        coordinator.push(.recipeView(Recipe(title: "Soup")))
                    } label: {
                        Text("Recipe")
                    }
                }
            }
        }
        
//        NavigationView {
//            coordinator.navigationLink()
//        }.onAppear { coordinator.push(.mintView) }
    }
}

struct ViewA_Previews: PreviewProvider {
    static var previews: some View {
        ViewA()
    }
}
