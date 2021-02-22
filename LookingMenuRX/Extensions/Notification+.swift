import Foundation
import UIKit

extension NotificationCenter {
    func postEvent(_ name: String) {
        post(name: Notification.Name(name), object: nil)
    }
}
