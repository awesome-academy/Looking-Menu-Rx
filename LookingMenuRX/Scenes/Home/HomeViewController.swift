import UIKit
import RxSwift
import RxCocoa
import Then
import MGArchitecture
import Reusable
import NSObject_Rx

private enum ConstantHomeView {
    static var sizeItemCollection = (width: CGFloat(), height: CGFloat())
}

final class HomeViewController: UIViewController, Bindable {
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var logoAppImageView: UIImageView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var randomRecipesCollection: UICollectionView!
    
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = HomeViewModel.Input(
            loadView: Driver.just(()),
            selectRecipe: randomRecipesCollection.rx.itemSelected.asDriver(),
            textSearchBar: searchBar.rx.text.orEmpty.asDriver(),
            endEditSeachBar: searchBar.rx.searchButtonClicked.asDriver(),
            tapSearchButton: searchButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$recipes
            .asDriver()
            .drive(randomRecipesCollection.rx.items) { collectionView, index, item in
                collectionView.dequeueReusableCell(
                    for: IndexPath(item: index, section: 0),
                    cellType: RecipeRandomCell.self)
                    .then {
                        $0.configItemRecipeRandom(item: item)
                    }
            }
            .disposed(by: rx.disposeBag)
        
        output.$isLoading
            .asDriver()
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ConstantHomeView.sizeItemCollection.width,
                      height:  ConstantHomeView.sizeItemCollection.height)
    }
}

extension HomeViewController {
    private func configView() {
        initView()
        configNavigationBar()
        configCollectionView()
        configImageView()
    }
    
    private func initView() {
        self.hideKeyboardWhenClick()
    }
    
    private func configCollectionView() {
        ConstantHomeView.sizeItemCollection.height = randomRecipesCollection.frame.height * 0.85
        ConstantHomeView.sizeItemCollection.width = randomRecipesCollection.frame.width / 1.5
        
        randomRecipesCollection.do {
            $0.collectionViewLayout.invalidateLayout()
            $0.rx.setDelegate(self)
                .disposed(by: rx.disposeBag)
        }
    }
    
    private func configImageView() {
        logoAppImageView.do {
            $0.cornerCircle()
        }
    }
    
    private func configNavigationBar() {
        navigationController?.do {
            $0.setNavigationBarHidden(true, animated: true)
        }
    }
}

extension HomeViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoardReference.home.storyBoard
}
