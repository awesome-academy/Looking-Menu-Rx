import UIKit

enum StoryBoardReference: String {
    case main = "Main"
    case home = "Home"
    case detail = "Detail"
    case ingredient = "Ingredient"
    case diet = "Diet"
    case favourite = "Favourite"
    
    var storyBoard: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}
