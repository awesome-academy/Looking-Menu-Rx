import Foundation
import UIKit

protocol DietNavigatorType {
    func goAddDietView()
    func goDetailView(recipe: Recipe)
    func showAlertError()
}

struct DietNavigator: DietNavigatorType {
    unowned let navigationController: UINavigationController
    
    func goAddDietView() {
        let viewController = AddDietViewController.instantiate()
        let useCase = AddDietUseCase()
        let navigator = AddDietNavigator(navigationController: navigationController)
        let viewModel = AddDietViewModel(navigator: navigator,
                                         usecase: useCase)
        
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goDetailView(recipe: Recipe) {
        let viewController = DetailRecipeController.instantiate()
        let useCase = DetailRecipeUseCase()
        let navigator = DetailRecipeNavigator(navigationController: navigationController)
        let viewModel = DetailRecipeViewModel(navigator: navigator, usecase: useCase, recipe: recipe)
        
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAlertError() {
        navigationController.showError()
    }
}
