import UIKit

extension UITextField {
    func paddingLeftTextField(width: CGFloat) {
        self.do {
            let paddingView = UIView(
                frame: CGRect(x: 0,
                              y: 0,
                              width: width,
                              height: frame.size.height))
            
            $0.leftView = paddingView
            $0.leftViewMode = .always
        }
    }
    
    func customPlaceHoder(text: String, color: UIColor = .white) {
        self.do {
            $0.attributedPlaceholder = NSAttributedString(
                string: text,
                attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
}
