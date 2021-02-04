import Foundation
import ObjectMapper

class ErrorResponse: Mappable {
    var message: String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        message <- map["message"]
    }
}
