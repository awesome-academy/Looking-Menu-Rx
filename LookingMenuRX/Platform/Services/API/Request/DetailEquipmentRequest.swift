import Foundation

final class DetailEquipmentRequest: BaseRequest {
    
    required init(idRecipe: Int) {
        let urlString = String(format: UrlAPIRecipe.urlDataEquipment, idRecipe)
        super.init(url: urlString, requestType: .get)
    }
}
