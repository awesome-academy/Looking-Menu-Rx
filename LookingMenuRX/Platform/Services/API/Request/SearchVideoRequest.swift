import Foundation

final class SearchVideoRequest: BaseRequest {
    
    required init(query: String) {
        let urlString = String(format: UrlAPIRecipe.urlDataVideoRecipe, query)
        super.init(url: urlString, requestType: .get)
    }
}
