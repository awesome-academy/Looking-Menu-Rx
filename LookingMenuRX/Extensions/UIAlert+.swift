import Foundation
import UIKit

extension UIAlertController {
    class func createDefaultAlert(title: String,
                                  message: String,
                                  style: UIAlertController.Style) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alert
    }
}
