import Foundation
import ObjectMapper
import Then

struct EquipmentsResponse {
    var equipment: [Detail]
}

extension EquipmentsResponse {
    init() {
        self.init(equipment: [Detail]())
    }
}

extension EquipmentsResponse: Then, Hashable {
    
}

extension EquipmentsResponse: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        equipment <- map["equipment"]
    }
}
