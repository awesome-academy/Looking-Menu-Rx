import UIKit

final class LoadingView: UIView {
    @IBOutlet weak private var loadingParentView: UIView!
    @IBOutlet weak private var loadingContainerView: UIView!
    @IBOutlet weak private var logoImageView: UIImageView!
    @IBOutlet weak private var loadingIndicatorView: UIActivityIndicatorView!
    
    static let instance = LoadingView()
    private let keyWindow = UIApplication.shared.connectedScenes
            .lazy
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func configLoadingView() {
        Bundle.main.loadNibNamed("LoadingScreen", owner: self, options: nil)
        loadingContainerView.layer.cornerRadius = 10
        logoImageView.cornerCircle()
        loadingIndicatorView.startAnimating()
    }
    
    func showLoading() {
        configLoadingView()
        keyWindow?.addSubview(loadingParentView)
    }
    
    func hideLoading() {
        keyWindow?.subviews.forEach {
            if $0 == loadingParentView {
                $0.removeFromSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
