import Foundation
import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxSwiftExt

extension UIViewController {
    func hideKeyboardWhenClick() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
