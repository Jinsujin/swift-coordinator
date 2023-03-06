import SwiftUI

struct Recipe: Identifiable, Hashable {
    let id = UUID()
    let title: String
}

struct RecipeListView: View {
    @StateObject var coordinator = Coordinator()
    
    private let recipeList: [Recipe] = [
        .init(title: "옥수수 스프"),
        .init(title: "그린 커리"),
        .init(title: "로제 파스타"),
        .init(title: "치킨 로스트"),
        .init(title: "미트볼"),
        .init(title: "치킨 버거"),
    ]
    
    var body: some View {
        NavigationStack{
            coordinator.navigationLink()
            LazyVStack {
                ForEach(recipeList) { recipe in
                    Button {
                        coordinator.push(.recipeView(recipe))
                    } label: {
                        Text(recipe.title)
                    }

                    // coordinator.navigationLink() 로 링크를 대신한다
//                    NavigationLink {
//                        RecipeView(recipe: recipe)
//                    } label: {
//                        Text(recipe.title)
//                    }
                }
            }
        }
        .onAppear { coordinator.destination = .recipeView(recipeList.first!) }
    }
}


struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack {
            Text("🍝")
            Text(recipe.title)
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
