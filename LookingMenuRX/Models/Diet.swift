import Foundation
import ObjectMapper
import Then

struct Diet {
    var id: Int = 1
    var name: String
    var calor: Double
    var recipeSessions: [RecipeSession]
}

extension Diet {
    init() {
        self.init(id: 0,
                  name: "",
                  calor: 0.0,
                  recipeSessions: [RecipeSession]()
        )
    }
}

extension Diet: Then, Hashable {
    
}

extension Diet: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        calor <- map["calor"]
        recipeSessions <- map["recipeSessions"]
    }
}
