import Foundation
import ObjectMapper
import Then

struct ResultSearchByIngredientsResponse {
    var id: Int
    var title: String
    var image: String
    var likes: Int
}

extension ResultSearchByIngredientsResponse {
    init() {
        self.init(
            id: 0,
            title: "",
            image: "",
            likes: 0
        )
    }
}

extension ResultSearchByIngredientsResponse: Then, Hashable {
    
}

extension ResultSearchByIngredientsResponse: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        image <- map["image"]
        likes <- map["likes"]
    }
}
