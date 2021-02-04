import Foundation
import ObjectMapper
import Then

struct RecipeDietResponse: Codable {
    var id: Int
    var title: String
    var image: String
}

extension RecipeDietResponse {
    init() {
        self.init(
            id: 0,
            title: "",
            image: ""
        )
    }
}

extension RecipeDietResponse: Then, Hashable {
    
}

extension RecipeDietResponse: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        image <- map["image"]
    }
}
