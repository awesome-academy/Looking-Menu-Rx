import Foundation

final class RecipesNutrientRequest: BaseRequest {
    
    required init(calor: Double) {
        let urlString = String(format: UrlAPIRecipe.urlRecipeNutrient, calor)
        super.init(url: urlString, requestType: .get)
    }
}
