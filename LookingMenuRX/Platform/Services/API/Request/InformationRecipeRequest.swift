import Foundation

final class InformationRecipeRequest: BaseRequest {
    
    required init(idRecipe: Int) {
        let urlString = String(format: UrlAPIRecipe.urlGetDetailRecipe, idRecipe)
        super.init(url: urlString, requestType: .get)
    }
}
