import Foundation
import ObjectMapper
import Then

struct RecipesResponse {
    var RecipesResponse: [Recipe]
}

extension RecipesResponse {
    init() {
        self.init(RecipesResponse: [Recipe]())
    }
}

extension RecipesResponse: Then, Hashable {
    
}

extension RecipesResponse: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        RecipesResponse <- map["RecipesResponse"]
    }
}
