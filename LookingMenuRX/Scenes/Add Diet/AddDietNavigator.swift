import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol AddDietNavigatorType {
    func showAlertAdd(recipes: [RecipeSession]) -> Observable<Diet>
    func goBackView()
}

struct AddDietNavigator: AddDietNavigatorType {
    unowned let navigationController: UINavigationController
    
    func showAlertAdd(recipes: [RecipeSession]) -> Observable<Diet> {
        return navigationController.showAlertAddDiet(recipes: recipes)
    }
    
    func goBackView() {
        navigationController.popViewController(animated: true)
    }
}
