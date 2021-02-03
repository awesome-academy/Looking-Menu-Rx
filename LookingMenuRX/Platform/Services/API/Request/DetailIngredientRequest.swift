import Foundation

final class DetailIngredientRequest: BaseRequest {
    
    required init(idRecipe: Int) {
        let urlString = String(format: UrlAPIRecipe.urlDataIngredient, idRecipe)
        super.init(url: urlString, requestType: .get)
    }
}
