import UIKit
import Reusable
import MGArchitecture
import RxSwift
import RxCocoa
import NSObject_Rx

private enum ConstantAddDietView {
    static let radiusView: CGFloat = 10
    static let heightDropDownTableCell: CGFloat = 50
    static let iconCheck = "checkmark.circle.fill"
    static let iconUnCheck = "xmark.circle.fill"
    static let textFieldHeightPlaceholder = "Insert in cm"
    static let textFieldWeightPlaceholder = "Insert in kg"
    static let textFieldAgePlaceholder = "Insert in year"
}

final class AddDietViewController: UIViewController, Bindable {
    @IBOutlet private weak var heightOfUserTextField: UITextField!
    @IBOutlet private weak var weightOfUserTextField: UITextField!
    @IBOutlet private weak var ageOfUserTextField: UITextField!
    @IBOutlet private weak var checkGenreMaleButton: UIButton!
    @IBOutlet private weak var checkGenreFemaleButton: UIButton!
    @IBOutlet private weak var dropDownActivityButton: UIButton!
    @IBOutlet private weak var dropDownActivityTableView: UITableView!
    @IBOutlet private weak var createDietButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    
    var viewModel: AddDietViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = AddDietViewModel.Input(
            loadTrigger: Driver.just(()),
            textFieldTrigger: Driver.combineLatest(
                heightOfUserTextField.rx.text.orEmpty.asDriver(),
                weightOfUserTextField.rx.text.orEmpty.asDriver(),
                ageOfUserTextField.rx.text.orEmpty.asDriver()),
            tapGenreButton: Driver.merge(
                checkGenreMaleButton.rx.tap.asDriver(), checkGenreFemaleButton.rx.tap.asDriver()),
            tapDropDownButton: dropDownActivityButton.rx.tap.asDriver(),
            selectTrigger: dropDownActivityTableView.rx.itemSelected.asDriver(),
            createDietButton: createDietButton.rx.tap.asDriver(),
            goBackTrigger: goBackButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$activities
            .asDriver()
            .drive(dropDownActivityTableView.rx.items) { tableView, index, item in
                tableView.dequeueReusableCell(
                    for: IndexPath(row: index, section: 0),
                    cellType: DropDownTableCell.self)
                    .then {
                        $0.configCell(activity: item.rawValue)
                        $0.selectionStyle = .none
                    }
            }
            .disposed(by: rx.disposeBag)
        
        dropDownActivityTableView.endUpdates()
        
        output.$enableButton
            .asDriver()
            .drive(createDietButton.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        output.$genreUser
            .asDriver()
            .drive(checkButtonGenre)
            .disposed(by: rx.disposeBag)
        
        output.$isDropdown
            .asDriver()
            .drive(dropDownActivityTableView.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        output.$titleActivityButton
            .asDriver()
            .map { $0.rawValue }
            .drive(dropDownActivityButton.rx.title())
            .disposed(by: rx.disposeBag)
    }
}

extension AddDietViewController {
    private var checkButtonGenre: Binder<Bool> {
        return Binder(self) { view, check in
            guard let imageMale = UIImage(
                    systemName: check ?
                    ConstantAddDietView.iconCheck : ConstantAddDietView.iconUnCheck),
                  let imageFeMale = UIImage(
                    systemName: check ?
                    ConstantAddDietView.iconUnCheck : ConstantAddDietView.iconCheck)
            else { return }
            
            view.checkGenreMaleButton.setBackgroundImage(imageMale,
                                                         for: .normal)
            view.checkGenreFemaleButton.setBackgroundImage(imageFeMale,
                                                           for: .normal)
            view.checkGenreMaleButton.tintColor = check ? .green : .red
            view.checkGenreFemaleButton.tintColor = check ? .red : .green
        }
    }
    
    private func configView() {
        self.hideKeyboardWhenClick()
        configTextField()
        configButton()
        configTableView()
    }
    
    private func configTextField() {
        [ (heightOfUserTextField, ConstantAddDietView.textFieldHeightPlaceholder),
          (weightOfUserTextField, ConstantAddDietView.textFieldWeightPlaceholder),
          (ageOfUserTextField, ConstantAddDietView.textFieldAgePlaceholder)].forEach {
            $0.0?.paddingLeftTextField()
            $0.0?.layer.masksToBounds = true
            $0.0?.cornerCircle()
            $0.0?.customPlaceHoder(text: $0.1)
          }
    }
    
    private func configButton() {
        [createDietButton, dropDownActivityButton].forEach {
            $0.cornerCircle()
        }
    }
    
    private func configTableView() {
        dropDownActivityTableView.do {
            $0.layer.cornerRadius = ConstantAddDietView.radiusView
            $0.register(cellType: DropDownTableCell.self)
            $0.rowHeight = ConstantAddDietView.heightDropDownTableCell
            $0.beginUpdates()
        }
    }
}

extension AddDietViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoardReference.diet.storyBoard
}
