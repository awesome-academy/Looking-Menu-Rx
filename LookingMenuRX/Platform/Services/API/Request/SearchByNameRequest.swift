import Foundation

final class SearchByNameRequest: BaseRequest {
    
    required init(query: String, offset: Int = 10) {
        let urlString = String(format: UrlAPIRecipe.urlSearchRecipeByName, query, offset)
        super.init(url: urlString, requestType: .get)
    }
}
