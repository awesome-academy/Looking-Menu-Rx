import Foundation
import ObjectMapper
import Then

struct Recipe {
    var id: Int
    var title: String
    var readyInMinutes: Int
    var image: String
}

extension Recipe {
    init() {
        self.init(
            id: 0,
            title: "",
            readyInMinutes: 0,
            image: ""
        )
    }
}

extension Recipe: Then, Hashable {
    
}

extension Recipe: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        readyInMinutes <- map["readyInMinutes"]
        image <- map["image"]
    }
}

extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
            && lhs.image == rhs.image
            && lhs.readyInMinutes == rhs.readyInMinutes
            && lhs.title == rhs.title
    }
}
