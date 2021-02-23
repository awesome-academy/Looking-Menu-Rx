import Foundation
import RxSwift
import RxCocoa

protocol FavouriteNavigatorType {
    func goDetailView(recipe: Recipe)
}

struct FavouriteNavigator: FavouriteNavigatorType {
    unowned let navigationController: UINavigationController
    
    func goDetailView(recipe: Recipe) {
        let viewController = DetailRecipeController.instantiate()
        let useCase = DetailRecipeUseCase()
        let navigator = DetailRecipeNavigator(navigationController: navigationController)
        let viewModel = DetailRecipeViewModel(navigator: navigator, usecase: useCase, recipe: recipe)
        
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
