import Foundation
import UIKit
import NSObject_Rx

extension UIView {
    func cornerCircle() {
        self.do {
            $0.layer.cornerRadius = frame.height / 2
            $0.clipsToBounds = true
        }
    }
    
    func addShadowView(radius: CGFloat) {
        self.do {
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = radius
            $0.layer.shadowColor = UIColor.blackDesign.cgColor
            $0.layer.shadowPath = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: layer.cornerRadius).cgPath
            $0.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowRadius = 1.0
        }
    }
}
