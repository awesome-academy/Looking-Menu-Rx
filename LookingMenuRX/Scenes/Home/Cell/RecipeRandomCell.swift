import UIKit
import Reusable
import SDWebImage
import Then

private enum ConstantRecipeRandomCelll {
    static let radiusView: CGFloat = 30
    static let constantAnchor: CGFloat = 4
    static let multiplierWidthBackGroundView: CGFloat = 0.75
    static let multiplierHeightImageRecipe: CGFloat = 0.55
    static let multiplierTopImageRecipe: CGFloat = 0.15
    static let fontSizeTitle = 24
    static let fontSizeMinute = 16
}

final class RecipeRandomCell: UICollectionViewCell, Reusable {
    
    lazy private var recipeCellBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = ConstantRecipeRandomCelll.radiusView
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy private var minuteLabel = UILabel().then {
        $0.setUpLabelCell(fontSize: ConstantRecipeRandomCelll.fontSizeMinute)
    }
    
    lazy private var titleLabel = UILabel().then {
        $0.setUpLabelCell(fontSize: ConstantRecipeRandomCelll.fontSizeTitle)
        $0.numberOfLines = 3
    }
    
    lazy private var recipeImageView = UIImageView().then {
        $0.layer.cornerRadius = ConstantRecipeRandomCelll.radiusView
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBackgroundView()
        addImageRecipe()
        addminuteLabelCook()
        addtitleLabelRecipe()
    }
    
    func configItemRecipeRandom(item: Recipe) {
        recipeImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        recipeImageView.sd_setImage(with: URL(string: item.image), completed: nil)
        titleLabel.text = item.title
        minuteLabel.text = "\(item.readyInMinutes) Minute"
    }
    
    private func addBackgroundView() {
        addSubview(recipeCellBackgroundView)
        
        NSLayoutConstraint.activate([
            recipeCellBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            recipeCellBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            recipeCellBackgroundView.widthAnchor.constraint(
                equalToConstant:
                    frame.width - (ConstantRecipeRandomCelll.constantAnchor * 4)),
            recipeCellBackgroundView.heightAnchor.constraint(
                equalToConstant:
                    frame.height * ConstantRecipeRandomCelll.multiplierWidthBackGroundView)
        ])
        
        recipeCellBackgroundView.addShadowView(radius: ConstantRecipeRandomCelll.radiusView)
    }
    
    private func addImageRecipe() {
        recipeCellBackgroundView.addSubview(recipeImageView)
        
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(
                equalTo: recipeCellBackgroundView.topAnchor,
                constant:
                    -(frame.width * ConstantRecipeRandomCelll.multiplierTopImageRecipe)),
            recipeImageView.centerXAnchor.constraint(equalTo: recipeCellBackgroundView.centerXAnchor),
            recipeImageView.widthAnchor.constraint(
                equalToConstant:
                    frame.width - (ConstantRecipeRandomCelll.constantAnchor * 10)),
            recipeImageView.heightAnchor.constraint(
                equalToConstant:
                    frame.height * ConstantRecipeRandomCelll.multiplierHeightImageRecipe)
        ])
    }
    
    private func addtitleLabelRecipe() {
        recipeCellBackgroundView.addSubview(titleLabel)
        titleLabel.textColor = .blackDesign
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: recipeImageView.bottomAnchor,
                constant: ConstantRecipeRandomCelll.constantAnchor),
            titleLabel.leadingAnchor.constraint(
                equalTo: recipeCellBackgroundView.leadingAnchor,
                constant: ConstantRecipeRandomCelll.constantAnchor),
            titleLabel.trailingAnchor.constraint(
                equalTo: recipeCellBackgroundView.trailingAnchor,
                constant: -ConstantRecipeRandomCelll.constantAnchor),
            titleLabel.bottomAnchor.constraint(
                equalTo: minuteLabel.topAnchor,
                constant: ConstantRecipeRandomCelll.constantAnchor)
        ])
    }
    
    private func addminuteLabelCook() {
        recipeCellBackgroundView.addSubview(minuteLabel)
        minuteLabel.textColor = .redDesign
        NSLayoutConstraint.activate([
            minuteLabel.bottomAnchor.constraint(
                equalTo: recipeCellBackgroundView.bottomAnchor,
                constant: -(ConstantRecipeRandomCelll.constantAnchor * 2)),
            minuteLabel.leadingAnchor.constraint(
                equalTo: recipeCellBackgroundView.leadingAnchor,
                constant: ConstantRecipeRandomCelll.constantAnchor),
            minuteLabel.trailingAnchor.constraint(
                equalTo: recipeCellBackgroundView.trailingAnchor,
                constant: -ConstantRecipeRandomCelll.constantAnchor)
        ])
    }
}
