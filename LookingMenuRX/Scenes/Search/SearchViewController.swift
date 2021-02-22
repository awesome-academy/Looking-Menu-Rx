import UIKit
import RxSwift
import RxCocoa
import Reusable
import MGArchitecture
import NSObject_Rx

private enum ConstantSearchView {
    static let radiusView: CGFloat = 20
    static let constantAnchor: CGFloat = -20
    static let multipleCollectionSize: CGFloat = 2.5
    static var sizeSeachCellCollection = (width: CGFloat(), height: CGFloat())
}

enum TypeSearch {
    case searchName
    case searchIngredient
}

final class SearchViewController: UIViewController, Bindable {
    @IBOutlet private weak var keyWordSearchTextField: UITextField!
    @IBOutlet private weak var slideView: UIView!
    @IBOutlet private weak var viewRecipeNotFound: UIStackView!
    @IBOutlet private weak var resultSearchCollection: UICollectionView!
    @IBOutlet private weak var constrantBottomSlideView: NSLayoutConstraint!
    @IBOutlet private weak var goBackButton: UIButton!
    
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = SearchViewModel.Input(
            textSearch: keyWordSearchTextField.rx.text.orEmpty.asDriver(),
            selectRecipe: resultSearchCollection.rx.itemSelected.asDriver(),
            backTrigger: goBackButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$recipes
            .asDriver()
            .drive(resultSearchCollection.rx.items) { collectionView, index, item in
                collectionView.dequeueReusableCell(
                    for: IndexPath(item: index, section: 0),
                    cellType: ResultSearchCell.self)
                    .then {
                        $0.configSearchCell(item: item)
                    }
            }
            .disposed(by: rx.disposeBag)
        
        output.$isEmptyRecipes
            .asDriver()
            .drive(emptyBinder)
            .disposed(by: rx.disposeBag)
        
        output.$isLoading
            .asDriver()
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
    }
    
    func finishSearchingRecipe() {
        constrantBottomSlideView.constant = ConstantSearchView.constantAnchor
        UIView.animate(withDuration: 1.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension SearchViewController: CustomSearchDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        sizeRecipeItem indexPath: IndexPath) -> CGSize {
        return CGSize(width: ConstantSearchView.sizeSeachCellCollection.width,
                      height: ConstantSearchView.sizeSeachCellCollection.height)
    }
}

extension SearchViewController {
    private var emptyBinder: Binder<Bool> {
        return Binder(self) { view, check in
            view.viewRecipeNotFound.isHidden = !check
            view.resultSearchCollection.isHidden = check
            view.finishSearchingRecipe()
        }
    }
    
    private func configView() {
        initView()
        configSlideView()
        configCollectionView()
    }
    
    private func initView() {
        self.hideKeyboardWhenClick()
        
        ConstantSearchView.sizeSeachCellCollection.height =
            view.frame.height / (ConstantSearchView.multipleCollectionSize + 0.5) 
        ConstantSearchView.sizeSeachCellCollection.width =
            view.frame.width / ConstantSearchView.multipleCollectionSize
        keyWordSearchTextField.text = viewModel.keyWord
    }
    
    private func configCollectionView() {
        let customLayout = CustomSearchCollectionViewLayout()
        customLayout.delegate = self
        
        resultSearchCollection.do {
            $0.collectionViewLayout = customLayout
        }
    }
    
    private func configSlideView() {
        slideView.do {
            $0.layer.cornerRadius = ConstantSearchView.radiusView
        }
    }
}

extension SearchViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoardReference.home.storyBoard
}
