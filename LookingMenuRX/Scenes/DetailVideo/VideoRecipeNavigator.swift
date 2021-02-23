import Foundation
import UIKit

protocol VideoRecipeNavigatorType {
    func goBackDetailView()
}

struct VideoRecipeNavigator: VideoRecipeNavigatorType {
    unowned let navigationController: UINavigationController
    
    func goBackDetailView() {
        navigationController.popViewController(animated: true)
    }
}
