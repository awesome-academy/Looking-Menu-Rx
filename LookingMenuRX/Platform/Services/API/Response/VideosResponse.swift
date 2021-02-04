import Foundation
import ObjectMapper
import Then

struct VideosResponse {
    var VideosResponse: [Video]
}

extension VideosResponse {
    init() {
        self.init(VideosResponse: [Video]())
    }
}

extension VideosResponse: Then, Hashable {
    
}

extension VideosResponse: BaseModel {

    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        VideosResponse <- map["VideosResponse"]
    }
}
