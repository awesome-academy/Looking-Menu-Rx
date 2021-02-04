import Foundation

final class SearchRecipesIngredientRequest: BaseRequest {
    
    required init(ingredients: String) {
        let urlString = String(format: UrlAPIRecipe.urlSearchByIngredients, ingredients)
        super.init(url: urlString, requestType: .get)
    }
}
