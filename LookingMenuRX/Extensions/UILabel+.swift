import Foundation
import UIKit

extension UILabel {
    func setUpLabelCell(fontSize: Int) {
        self.do {
            $0.font = .boldSystemFont(ofSize: CGFloat(fontSize))
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.5
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
