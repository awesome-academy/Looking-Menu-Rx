import Foundation
import UIKit

protocol TextRecipeNavigatorType {
    func goBackDetail()
}

struct TextRecipeNavigator: TextRecipeNavigatorType {
    unowned let navigationController: UINavigationController
    
    func goBackDetail() {
        navigationController.popViewController(animated: true)
    }
}
