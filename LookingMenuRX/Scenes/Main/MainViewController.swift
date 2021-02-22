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
    @IBOutlet private var containers: [UIView]!
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
            for (index, element) in view.containers.enumerated() {
                element.isHidden = index != item
            }
        }
    }
    
    private func configView() {
        initMainView()
        configNavigationView()
        configCollectionView()
    }
    
    private func initMainView() {
        for (index, element) in containers.enumerated() {
            element.isHidden = index != 0
        }
    }
    
    private func configNavigationView() {
        navigationController?.do {
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
