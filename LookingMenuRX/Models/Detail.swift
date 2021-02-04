import Foundation
import ObjectMapper
import Then

struct Detail {
    var name: String
    var image: String
}

extension Detail {
    init() {
        self.init(name: "", image: "")
    }
}

extension Detail: Then, Hashable {
    
}

extension Detail: BaseModel {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        image <- map["image"]
    }
}
