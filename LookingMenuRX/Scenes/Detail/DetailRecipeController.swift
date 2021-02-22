import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Reusable
import NSObject_Rx
import MGArchitecture

final class DetailRecipeController: UIViewController, Bindable {
    @IBOutlet private var changeTableLabel: [UILabel]!
    @IBOutlet private weak var goDetailRecipeTextButton: UIButton!
    @IBOutlet private weak var goDetailRecipeVideoButton: UIButton!
    @IBOutlet private weak var bottomBarViewCenterEquipConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomBarViewCenterIngreConstraint: NSLayoutConstraint!
    @IBOutlet private weak var recipeImage: UIImageView!
    @IBOutlet private weak var nameRecipeLabel: UILabel!
    @IBOutlet private weak var minuteCookingLabel: UILabel!
    @IBOutlet private weak var ingredientTableView: UITableView!
    @IBOutlet private weak var equipmentTableView: UITableView!
    @IBOutlet private weak var bottomBarView: UIView!
    @IBOutlet weak var recipeFavouriteButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    
    var viewModel: DetailRecipeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = DetailRecipeViewModel.Input(
            loadTrigger: Driver.just(()),
            tapFavouriteButton: recipeFavouriteButton.rx.tap.asDriver(),
            tapGoVideo: goDetailRecipeVideoButton.rx.tap.asDriver(),
            tapGoText: goDetailRecipeTextButton.rx.tap.asDriver(),
            backTrigger: goBackButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$equipmentTrigger
            .asDriver()
            .drive(equipmentTableView.rx.items) { tableView, index, detail in
                tableView.dequeueReusableCell(
                    for: IndexPath(item: index, section: 0),
                    cellType: DetailRecipeCell.self)
                    .then {
                        $0.configDetailRecipeCell(item: detail, typeDetailCell: false)
                    }
            }
            .disposed(by: rx.disposeBag)
        
        output.$ingredientTrigger
            .asDriver()
            .drive(ingredientTableView.rx.items) { tableView, index, detail in
                tableView.dequeueReusableCell(
                    for: IndexPath(item: index, section: 0),
                    cellType: DetailRecipeCell.self)
                    .then {
                        $0.configDetailRecipeCell(item: detail, typeDetailCell: true)
                    }
            }
            .disposed(by: rx.disposeBag)
        
        [ingredientTableView, equipmentTableView].forEach { $0?.endUpdates() }
        
        changeTableLabel.forEach {
            $0.rx
                .tapGesture()
                .when(.recognized)
                .map { $0.view == self.changeTableLabel[0] }
                .subscribe { self.clickLabel($0) }
                .disposed(by: rx.disposeBag)
        }
        
        output.$isFavourite
            .asDriver()
            .drive(backgroundButtonBinding)
            .disposed(by: rx.disposeBag)
    }
}

extension DetailRecipeController {
    var backgroundButtonBinding: Binder<Bool> {
        return Binder(self) { viewController, check in
            let image = check ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            viewController.recipeFavouriteButton.setBackgroundImage(image, for: .normal)
        }
    }
    
    private func configView() {
        cornerCircleUI()
        configDetailRecipe()
        configTableView()
    }
    
    private func configDetailRecipe() {
        let url = URL(string: viewModel.recipe.image)
        recipeImage.sd_setImage(with: url, completed: nil)
        nameRecipeLabel.text = viewModel.recipe.title
        minuteCookingLabel.text = "\(viewModel.recipe.readyInMinutes) Minute"
    }
    
    private func cornerCircleUI() {
        [ bottomBarView,
          recipeImage,
          goDetailRecipeTextButton,
          goDetailRecipeVideoButton].forEach {
            $0?.cornerCircle()
          }
    }
    
    private func configTableView() {
        [ ingredientTableView,
          equipmentTableView].forEach {
            $0?.rowHeight = 80
            $0?.beginUpdates()
            $0?.register(cellType: DetailRecipeCell.self)
          }
        
        ingredientTableView.do {
            $0.alpha = 0.0
        }
    }
    
    @objc private func clickLabel(_ type: Bool) {
        changeTableLabel[0].textColor = type ? .redDesign : .blackDesign
        changeTableLabel[1].textColor = type ? .blackDesign : .redDesign
        bottomBarViewCenterEquipConstraint.priority = type ? .defaultHigh : .defaultLow
        bottomBarViewCenterIngreConstraint.priority = type ? .defaultLow : .defaultHigh
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.equipmentTableView.alpha = type ? 1.0 : 0.0
                        self.ingredientTableView.alpha = type ? 0.0 : 1.0
                       }, completion: nil)
    }
}

extension DetailRecipeController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoardReference.detail.storyBoard
}
