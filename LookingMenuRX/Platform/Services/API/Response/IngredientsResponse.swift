import Foundation
import ObjectMapper
import Then

struct IngredientsResponse {
    var ingredient: [Detail]
}

extension IngredientsResponse {
    init() {
        self.init(ingredient: [Detail]())
    }
}

extension IngredientsResponse: Then, Hashable {
    
}

extension IngredientsResponse: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        ingredient <- map["ingredient"]
    }
}
