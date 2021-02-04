import Foundation
import ObjectMapper
import Then

struct Step {
    var number: Int
    var step: String
}

extension Step {
    init() {
        self.init(number: 0, step: "")
    }
}

extension Step: Then, Hashable {
    
}

extension Step: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        number <- map["number"]
        step <- map["step"]
    }
}
