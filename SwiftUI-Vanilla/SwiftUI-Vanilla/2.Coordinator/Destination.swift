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
