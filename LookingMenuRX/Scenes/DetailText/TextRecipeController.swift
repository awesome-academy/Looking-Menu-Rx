import UIKit
import RxSwift
import RxCocoa
import Reusable
import MGArchitecture
import NSObject_Rx

final class TextRecipeController: UIViewController, Bindable {
    @IBOutlet private weak var minuteReadyLabel: UILabel!
    @IBOutlet private weak var titleRecipeLabel: UILabel!
    @IBOutlet private weak var priceRecipeLabel: UILabel!
    @IBOutlet private weak var numberServingLabel: UILabel!
    @IBOutlet private weak var stepTaskTabelView: UITableView!
    @IBOutlet private weak var goBackButton: UIButton!
    
    var viewModel: TextRecipeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        let input = TextRecipeViewModel.Input(loadTrigger: Driver.just(()),
                                              goBackTrigger: goBackButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$information
            .asDriver()
            .drive(infomationBinder)
            .disposed(by: rx.disposeBag)
        
        stepTaskTabelView.beginUpdates()
        
        output.$steps
            .asDriver()
            .drive(stepTaskTabelView.rx.items) { tableView, index, step in
                tableView.dequeueReusableCell(
                    for: IndexPath(row: index, section: 0),
                    cellType: StepTaskCell.self)
                    .then {
                        $0.configStepTaskCell(item: step)
                    }
            }
            .disposed(by: rx.disposeBag)
        
        stepTaskTabelView.endUpdates()
    }
}

extension TextRecipeController {
    private var infomationBinder: Binder<Information> {
        return Binder(self) { view, info in
            view.minuteReadyLabel.text = "\(info.readyInMinutes) minute"
            view.priceRecipeLabel.text = "\(info.pricePerServing) $"
            view.numberServingLabel.text = "\(info.servings)"
            view.titleRecipeLabel.text = view.viewModel.recipe.title
        }
    }
}

extension TextRecipeController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoardReference.detail.storyBoard
}
