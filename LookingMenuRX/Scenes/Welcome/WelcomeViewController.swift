import UIKit
import Foundation
import RxCocoa
import RxSwift
import MGArchitecture
import NSObject_Rx
import Reusable

final class WelcomeViewController: UIViewController, Bindable {
    @IBOutlet private weak var iconLogo: UIImageView!
    @IBOutlet private weak var buttonStated: UIButton!
    
    var viewModel: WelcomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = WelcomeViewModel.Input(btnGoMainView: buttonStated.rx.tap.asDriver())
        let _ = viewModel.transform(input, disposeBag: rx.disposeBag)
    }
}

extension WelcomeViewController {
    private func configView() {
        configIconLogo()
        configButtonStarted()
        configNavigation()
    }
    
    private func configIconLogo() {
        iconLogo.do {
            $0.cornerCircle()
        }
    }
    
    private func configButtonStarted() {
        buttonStated.do {
            $0.cornerCircle()
        }
    }
    
    private func configNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension WelcomeViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoardReference.main.storyBoard
}
