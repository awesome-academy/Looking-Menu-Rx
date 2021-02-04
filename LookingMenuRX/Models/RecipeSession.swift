import Foundation
import ObjectMapper
import Then

struct RecipeSession {
    var date: Date
    var recipes: [RecipeDietResponse]
    
    init(date: Date, recipes: [RecipeDietResponse]) {
        self.date = date
        self.recipes = recipes
    }
}

extension RecipeSession {
    init() {
        self.init(date: Date(), recipes: [RecipeDietResponse]())
    }
}

extension RecipeSession: Then, Hashable {
    
}

extension RecipeSession: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        date <- map["date"]
        recipes <- map["recipes"]
    }
}
