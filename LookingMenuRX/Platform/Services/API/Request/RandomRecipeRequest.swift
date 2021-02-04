import Foundation

final class RandomRecipeRequest: BaseRequest {
    
    required init(offset: Int = 5) {
        let urlString = String(format: UrlAPIRecipe.urlGetRecipeRandom, offset)
        super.init(url: urlString, requestType: .get)
    }
}
