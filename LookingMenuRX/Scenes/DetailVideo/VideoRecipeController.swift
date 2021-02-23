import UIKit
import WebKit
import MGArchitecture
import Reusable
import NSObject_Rx
import RxSwift
import RxCocoa

final class VideoRecipeController: UIViewController, Bindable {
    @IBOutlet private weak var nameRecipeLabel: UILabel!
    @IBOutlet private weak var videoEmbedYoutubeWebView: WKWebView!
    @IBOutlet private weak var titleVideoLabel: UILabel!
    @IBOutlet private weak var ratingVideoLabel: UILabel!
    @IBOutlet private weak var viewVideoLabel: UILabel!
    @IBOutlet private weak var goBackButton: UIButton!
    @IBOutlet private weak var lengthVideoLabel: UILabel!
    
    var viewModel: VideoRecipeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        let input = VideoRecipeViewModel.Input(loadTrigger: Driver.just(()),
                                               goBackTrigger: goBackButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$video
            .asDriver()
            .drive(videoBinder)
            .disposed(by: rx.disposeBag)
    }
}

extension VideoRecipeController {
    private var videoBinder: Binder<Videos> {
        return Binder(self) { view, videos in
            if let video = videos.videos.first {
                view.nameRecipeLabel.text = view.viewModel.recipe.title
                view.titleVideoLabel.text = video.shortTitle
                view.ratingVideoLabel.text = "\(video.rating)"
                view.viewVideoLabel.text = "\(video.views)"
                view.lengthVideoLabel.text = "\(view.convertSecondToMinute(totalVideoDuration: video.length))"
                view.loadVideoEmbedYoutube(id: video.youTubeId)
            }
        }
    }
    
    private func loadVideoEmbedYoutube(id: String) {
        guard let myUrl = URL(string: String(format: UrlAPIRecipe.urlEmbebYoutube, id))
        else { return }
        let request = URLRequest(url: myUrl)
        videoEmbedYoutubeWebView.load(request)
    }
    
    private func convertSecondToMinute(totalVideoDuration: Int) -> String {
        return String(format:"%02d:%02d",
                      totalVideoDuration / 60,
                      totalVideoDuration % 60);
    }
}

extension VideoRecipeController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoardReference.detail.storyBoard
}
