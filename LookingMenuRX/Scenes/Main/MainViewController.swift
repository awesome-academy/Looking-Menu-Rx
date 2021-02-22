import Foundation
import UIKit
import RxCocoa
import RxSwift
import MGArchitecture
import NSObject_Rx
import Reusable

private enum ConstantMainViewController {
    static let heightOfTabBarCollection: CGFloat = 100
    static var widthOfTabBarCollection: CGFloat = 0
}

final class MainViewController: UIViewController, Bindable {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var tabBarCollection: UICollectionView!
    
    var viewModel: MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        let input = MainViewModel.Input(selectTrigger: tabBarCollection.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$itemTabbars
            .asDriver()
            .drive(tabBarCollection.rx.items) { collectionView, index, item in
                collectionView.dequeueReusableCell(
                    for: IndexPath(item: index, section: 0),
                    cellType: TabBarCollectionViewCell.self)
                    .then {
                        $0.configCell(name: item)
                    }
            }
            .disposed(by: rx.disposeBag)
        
        tabBarCollection.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        output.$selectTabBar
            .asDriver()
            .drive(tabBarBinder)
            .disposed(by: rx.disposeBag)
        
        configView()
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ConstantMainViewController.widthOfTabBarCollection,
                      height: ConstantMainViewController.heightOfTabBarCollection)
    }
}

extension MainViewController {
    private var tabBarBinder: Binder<Int> {
        return Binder(self) { view, item in
            switch item {
            case 0:
                view.goHomeView()
            case 1:
                view.goFavouriteView()
            case 2:
                view.goDietView()
            case 3:
                view.goIngredientView()
            default: view.goHomeView()
            }
        }
    }
    
    private func configView() {
        goHomeView()
        configNavigationView()
        configCollectionView()
    }
    
    private func goHomeView() {
        let viewController = HomeViewController.instantiate()
        
        viewController.willMove(toParent: self)
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewController.view.frame = containerView.bounds
        self.containerView.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
        
        let usecase = HomeUseCase()
        let navigator = HomeNavigator(
            navigationController: viewModel.navigation)
        let homeViewModel = HomeViewModel(navigator: navigator, useCase: usecase)
        viewController.bindViewModel(to: homeViewModel)
    }
    
    private func goFavouriteView() {
        let viewController = FavouriteController.instantiate()
        
        viewController.willMove(toParent: self)
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewController.view.frame = containerView.bounds
        self.containerView.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
        
        let useCase = FavouriteUseCase()
        let navigator = FavouriteNavigator(
            navigationController: viewModel.navigation)
        let viewModel = FavouriteViewModel(usecase: useCase, navigator: navigator)
        viewController.bindViewModel(to: viewModel)
    }
    
    private func goDietView() {
        let viewController = DietController.instantiate()
        
        viewController.willMove(toParent: self)
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewController.view.frame = containerView.bounds
        self.containerView.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
        
        let useCase = DietUseCase()
        let navigator = DietNavigator(
            navigationController: viewModel.navigation)
        let viewModel = DietViewModel(usecase: useCase, navigator: navigator)
        viewController.bindViewModel(to: viewModel)
    }
    
    private func goIngredientView() {
        let viewController = IngredientController.instantiate()
        
        viewController.willMove(toParent: self)
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewController.view.frame = containerView.bounds
        self.containerView.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
        
        let navigator = IngredientNavigation(
            navigationController: viewModel.navigation)
        let viewModel = IngredientViewModel(navigator: navigator)
        viewController.bindViewModel(to: viewModel)
    }
    private func configNavigationView() {
        viewModel.navigation.do {
            $0.setNavigationBarHidden(true, animated: true)
        }
    }
    
    private func configCollectionView() {
        tabBarCollection.do {
            ConstantMainViewController.widthOfTabBarCollection = (view.frame.width - 24) / 4
            $0.collectionViewLayout.invalidateLayout()
            $0.register(cellType: TabBarCollectionViewCell.self)
            $0.selectItem(
                at: IndexPath(item: 0, section: 0),
                animated: true,
                scrollPosition: .centeredHorizontally)
        }
    }
}

extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoardReference.main.storyBoard
}
