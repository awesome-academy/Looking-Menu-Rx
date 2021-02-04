import Foundation
import RxSwift
import RxCocoa

protocol AppNavigatorType {
    func toMain()
}

struct AppNavigator: AppNavigatorType {
    unowned let window: UIWindow
    
    func toMain() {
        let isNewUser =  UserDefaults.standard.bool(forKey: KeyUserDefaults.keyCheckNewUser)
        if isNewUser {
            let viewController = MainViewController.instantiate()
            let viewModel = MainViewModel()
            viewController.bindViewModel(to: viewModel)
            window.rootViewController = viewController
        } else {
            let viewController = WelcomeViewController.instantiate()
            let navigator = WelcomeViewNavigator(window: window)
            let viewModel = WelcomeViewModel(navigator: navigator)
            viewController.bindViewModel(to: viewModel)
            window.rootViewController = viewController
        }
        window.makeKeyAndVisible()
    }
}
