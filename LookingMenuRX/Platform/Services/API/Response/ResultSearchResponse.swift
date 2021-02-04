import Foundation
import ObjectMapper
import Then

struct ResultSearchResponse {
    var results: [Recipe]
    var totalResults: Int
}

extension ResultSearchResponse {
    init() {
        self.init(
            results: [Recipe](),
            totalResults: 0
        )
    }
}

extension ResultSearchResponse: Then, Hashable {
    
}

extension ResultSearchResponse: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        results <- map["results"]
        totalResults <- map["totalResults"]
    }
}

extension ResultSearchResponse: Equatable {
    static func == (lhs: ResultSearchResponse, rhs: ResultSearchResponse) -> Bool {
        return lhs.totalResults == rhs.totalResults
            && lhs.results == rhs.results
    }
}
