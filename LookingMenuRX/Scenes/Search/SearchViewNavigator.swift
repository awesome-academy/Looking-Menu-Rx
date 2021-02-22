import Foundation
import RxSwift
import RxCocoa

protocol SearchViewNavigatorType {
    func goDetailView(recipe: Recipe)
    func goBackView()
}

struct SearchViewNavigator: SearchViewNavigatorType {
    unowned let navigationController: UINavigationController
    
    func goDetailView(recipe: Recipe) {
        let viewController = DetailRecipeController.instantiate()
        let useCase = DetailRecipeUseCase()
        let navigator = DetailRecipeNavigator(navigationController: navigationController)
        let viewModel = DetailRecipeViewModel(navigator: navigator, usecase: useCase, recipe: recipe)
        
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goBackView() {
        navigationController.popViewController(animated: true)
    }
}
