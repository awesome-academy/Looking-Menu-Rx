import UIKit
import Reusable
import SDWebImage
import Then

private enum ConstantRecipeCell {
    static let radiusView: CGFloat = 20
    static let fontSizeTitle = 24
    static let constantAnchor: CGFloat = 8
    static let constantDetailBG: CGFloat = 4
}

final class DetailRecipeCell: UITableViewCell, Reusable {
    lazy private var detailRecipeBackground = UIView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy private var detailRecipeImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy private var detailRecipeTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .blackDesign
        $0.setUpLabelCell(fontSize: ConstantRecipeCell.fontSizeTitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addDetailBackground()
    }
    
    func configDetailRecipeCell(item: Detail, typeDetailCell: Bool) {
        let url = URL(string: String(format: UrlAPIRecipe.urlImageRecipeDetail,
                                     typeDetailCell ? "ingredients" : "equipment",
                                     item.image))
        detailRecipeImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        detailRecipeImageView.sd_setImage(with: url, completed: nil)
        detailRecipeTitleLabel.text = item.name
    }
    
    private func addDetailTitle() {
        detailRecipeBackground.addSubview(detailRecipeTitleLabel)
        NSLayoutConstraint.activate([
            detailRecipeTitleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -ConstantRecipeCell.constantAnchor),
            detailRecipeTitleLabel.leadingAnchor.constraint(
                equalTo: detailRecipeImageView.trailingAnchor,
                constant: ConstantRecipeCell.constantAnchor),
            detailRecipeTitleLabel.centerYAnchor.constraint(equalTo: detailRecipeImageView.centerYAnchor)
        ])
    }
    
    private func addDetailImage() {
        detailRecipeBackground.addSubview(detailRecipeImageView)
        NSLayoutConstraint.activate([
            detailRecipeImageView.leadingAnchor.constraint(
                equalTo:detailRecipeBackground.leadingAnchor,
                constant: ConstantRecipeCell.constantAnchor),
            detailRecipeImageView.widthAnchor.constraint(equalToConstant: frame.width * 0.4),
            detailRecipeImageView.topAnchor.constraint(
                equalTo: detailRecipeBackground.topAnchor,
                constant: ConstantRecipeCell.constantDetailBG),
            detailRecipeImageView.bottomAnchor.constraint(
                equalTo: detailRecipeBackground.bottomAnchor,
                constant: -ConstantRecipeCell.constantDetailBG)
        ])
        detailRecipeImageView.cornerCircle()
    }
    
    private func addDetailBackground() {
        addSubview(detailRecipeBackground)
        NSLayoutConstraint.activate([
            detailRecipeBackground.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: ConstantRecipeCell.constantDetailBG),
            detailRecipeBackground.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -ConstantRecipeCell.constantDetailBG),
            detailRecipeBackground.topAnchor.constraint(
                equalTo: topAnchor,
                constant: ConstantRecipeCell.constantDetailBG),
            detailRecipeBackground.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -ConstantRecipeCell.constantDetailBG)
        ])

        detailRecipeBackground.cornerCircle()
        addDetailImage()
        addDetailTitle()
    }
}
