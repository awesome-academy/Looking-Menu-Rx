import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import RxGesture
import NSObject_Rx
import SDWebImage

private enum ConstantDietView {
    static let cornerRadius = 5
    static let heightDropDownTableView: CGFloat = 50
}

final class DietController: UIViewController, Bindable {
    @IBOutlet private weak var listDietTableView: UITableView!
    @IBOutlet private weak var tapDropdowButton: UIButton!
    @IBOutlet private weak var addDietButton: UIButton!
    @IBOutlet private weak var heightTableViewConstraint: NSLayoutConstraint!
    @IBOutlet private var iconSessionImageView: [UIImageView]!
    @IBOutlet private var bottomBarCenterConstraint: [NSLayoutConstraint]!
    @IBOutlet private weak var bottomBarView: UIView!
    @IBOutlet private weak var dietDatePicker: UIDatePicker!
    @IBOutlet private weak var recipeSessionImageView: UIImageView!
    @IBOutlet private weak var recipeSesssionTitleLabel: UILabel!
    @IBOutlet private weak var showRecipeStackView: UIStackView!
    
    var viewModel: DietViewModel!
    @Property var selectSession = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = DietViewModel.Input(
            loadTrigger: Driver.just(()),
            goAddDietTrigger: addDietButton.rx.tap.asDriver(),
            tapDropdown: tapDropdowButton.rx.tap.asDriver(),
            selectTrigger: listDietTableView.rx.itemSelected.asDriver(),
            selectSession: $selectSession.asDriver(),
            selectDateTrigger: dietDatePicker.rx.date.asDriverOnErrorJustComplete(),
            notification: NotificationCenter.default.rx.notification(Notification.Name("addDiet"))
                .asDriverOnErrorJustComplete(),
            deleteTrigger: listDietTableView.rx.itemDeleted.asDriver(),
            goDetailTrigger: showRecipeStackView.rx.tapGesture()
                .when(.recognized)
                .asDriverOnErrorJustComplete()
                .mapToVoid())
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$diets
            .asDriver()
            .drive(listDietTableView.rx.items) { tableView, index, diet in
                tableView.dequeueReusableCell(
                    for: IndexPath(row: index, section: 0),
                    cellType: DropDownTableCell.self)
                    .then {
                        $0.configCell(activity: diet.name)
                        $0.selectionStyle = .none
                    }
            }
            .disposed(by: rx.disposeBag)
        
        output.$diets
            .asDriver()
            .map { CGFloat($0.count) * ConstantDietView.heightDropDownTableView }
            .drive(heightTableView)
            .disposed(by: rx.disposeBag)
        
        output.$isDropDown
            .asDriver()
            .drive(listDietTableView.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        output.$selectDiet
            .asDriver()
            .map { $0.name }
            .drive(tapDropdowButton.rx.title())
            .disposed(by: rx.disposeBag)
        
        output.$selectSessionRecipe
            .asDriver()
            .drive(recipeSessionBind)
            .disposed(by: rx.disposeBag)
        
        for (index, element) in iconSessionImageView.enumerated() {
            element.rx
                .tapGesture()
                .when(.recognized)
                .map { _ in index }
                .do { [unowned self] session in
                    iconSessionImageView.forEach {
                        $0.tintColor = $0 == element ? .redDesign : .blackDesign
                    }
                    
                    for (index, element) in bottomBarCenterConstraint.enumerated() {
                        element.priority = index == session ? .defaultHigh : .defaultLow
                    }
                    
                    configAnimation()
                }
                .asDriverOnErrorJustComplete()
                .drive($selectSession)
                .disposed(by: rx.disposeBag)
        }
    }
}

extension DietController {
    private var heightTableView: Binder<CGFloat> {
        return Binder(self) { view, constant in
            view.heightTableViewConstraint.constant = constant
        }
    }
    
    private var recipeSessionBind: Binder<RecipeDiet> {
        return Binder(self) { view, recipe in
            let url = URL(string: recipe.image)
            view.recipeSesssionTitleLabel.text = recipe.title
            view.recipeSessionImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            view.recipeSessionImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    private func configView() {
        configNavigation()
        configTableView()
        configBottonView()
        self.hideKeyboardWhenClick()
    }
    
    private func configAnimation() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                       }, completion: nil)
    }
    
    private func configNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func configBottonView() {
        bottomBarView.do {
            $0.cornerCircle()
        }
    }
    
    private func configTableView() {
        listDietTableView.do {
            $0.rowHeight = ConstantDietView.heightDropDownTableView
            $0.register(cellType: DropDownTableCell.self)
            $0.isHidden = true
        }
    }
}

extension DietController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoardReference.diet.storyBoard
}
