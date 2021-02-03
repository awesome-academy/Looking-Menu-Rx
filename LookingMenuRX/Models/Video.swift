import Foundation
import ObjectMapper
import Then

struct Video {
    var shortTitle: String
    var youTubeId: String
    var rating: Float
    var views: Int
    var thumbnail: String
    var length: Int
}

extension Video {
    init() {
        self.init(
            shortTitle: "",
            youTubeId: "",
            rating: 0.0,
            views: 0,
            thumbnail: "",
            length: 0
        )
    }
}

extension Video: Then, Hashable {
    
}

extension Video: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        shortTitle <- map["shortTitle"]
        youTubeId <- map["youTubeId"]
        rating <- map["rating"]
        views <- map["views"]
        thumbnail <- map["thumbnail"]
        length <- map["length"]
    }
}
