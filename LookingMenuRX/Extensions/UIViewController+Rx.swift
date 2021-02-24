import Foundation
import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

extension Reactive where Base: UIViewController {
    var isLoading: Binder<Bool> {
        let loadingView = LoadingView()
        return Binder(base) { viewController, isLoading in
            if isLoading {
                loadingView.showLoading()
            } else {
                loadingView.hideLoading()
            }
        }
    }
}

extension UIViewController {
    func showAlert(title: String,
                   message: String,
                   style: UIAlertController.Style) {
        let alert = UIAlertController
            .createDefaultAlert(title: title, message: message, style: style)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertTextField(recipes: [RecipeSession]) -> Observable<Diet> {
        return Observable.create { [unowned self] observer in
            let alert = UIAlertController.createDefaultAlert(title: "Agree Add Diet ? ",
                                                             message: "What's name diet?",
                                                             style: .alert)
            
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Input diet name here..."
            })
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  action in
                if let name = alert.textFields?.first?.text {
                    observer.onNext(Diet(name: name, recipeSessions: recipes))
                    observer.onCompleted()
                }
            }))
            
            present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
