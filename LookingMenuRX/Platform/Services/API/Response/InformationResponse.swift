import Foundation
import ObjectMapper
import Then

struct InformationResponse {
    var readyInMinutes: Int
    var servings: Int
    var pricePerServing: Float
    var analyzedInstructions: [Step]
}

extension InformationResponse {
    init() {
        self.init(
            readyInMinutes: 0,
            servings: 0,
            pricePerServing: 0.0,
            analyzedInstructions: [Step]()
        )
    }
}

extension InformationResponse: Then, Hashable {
    
}

extension InformationResponse: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        readyInMinutes <- map["readyInMinutes"]
        servings <- map["servings"]
        pricePerServing <- map["pricePerServing"]
        analyzedInstructions <- map["analyzedInstructions"]["steps"]
    }
}
