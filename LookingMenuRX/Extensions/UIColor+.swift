import Foundation
import UIKit

extension UIColor {
    public class var redDesign: UIColor {
        UIColor(named: "red") ?? .red
    }
    
    public class var blackDesign: UIColor {
        UIColor(named: "black") ?? .black
    }
    
    public class var grayDesign: UIColor {
        UIColor(named: "gray") ?? .gray
    }
}
