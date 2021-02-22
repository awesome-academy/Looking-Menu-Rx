import UIKit
import SDWebImage
import Reusable
import Then

private enum ConstantResultSearchCell {
    static let radiusView: CGFloat = 20
    static let constantAnchor: CGFloat = 4
    static let paddingRecipeImage: CGFloat = 16
    static let topView: CGFloat = 50
    static let fontSizeLabelMinute = 20
    static let fontSizeLabelTitle = 16
}

final class ResultSearchCell: UICollectionViewCell, Reusable {
    
    private lazy var containerResultCell = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = ConstantResultSearchCell.radiusView
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var recipeImage = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var minuteCookingLabel = UILabel().then {
        $0.textColor = .redDesign
        $0.setUpLabelCell(fontSize: ConstantResultSearchCell.fontSizeLabelMinute)
    }
    
    private lazy var titleRecipeLabel = UILabel().then {
        $0.numberOfLines = 3
        $0.textColor = .blackDesign
        $0.setUpLabelCell(fontSize: ConstantResultSearchCell.fontSizeLabelTitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addContainerView()
    }
    
    func configSearchCell(item: Recipe) {
        recipeImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        recipeImage.sd_setImage(with: URL(string: item.image), completed: nil)
        minuteCookingLabel.text = "\(item.readyInMinutes) Minutes"
        titleRecipeLabel.text = item.title
    }
    
    
    private func addLabelMinute() {
        containerResultCell.addSubview(minuteCookingLabel)
        NSLayoutConstraint.activate([
            minuteCookingLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: ConstantResultSearchCell.constantAnchor),
            minuteCookingLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -ConstantResultSearchCell.constantAnchor),
            minuteCookingLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -(ConstantResultSearchCell.constantAnchor * 2))
        ])
    }
    
    private func addLabelTitle() {
        containerResultCell.addSubview(titleRecipeLabel)
        NSLayoutConstraint.activate([
            titleRecipeLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: ConstantResultSearchCell.constantAnchor),
            titleRecipeLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -ConstantResultSearchCell.constantAnchor),
            titleRecipeLabel.topAnchor.constraint(
                equalTo: recipeImage.bottomAnchor,
                constant: ConstantResultSearchCell.constantAnchor),
            titleRecipeLabel.bottomAnchor.constraint(
                equalTo: minuteCookingLabel.bottomAnchor,
                constant: -ConstantResultSearchCell.constantAnchor)
        ])
    }
    
    private func addImageView() {
        containerResultCell.addSubview(recipeImage)
        NSLayoutConstraint.activate([
            recipeImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            recipeImage.widthAnchor.constraint(equalToConstant:
                                                frame.width - ConstantResultSearchCell.paddingRecipeImage),
            recipeImage.heightAnchor.constraint(equalToConstant:
                                                    frame.width - ConstantResultSearchCell.paddingRecipeImage),
            recipeImage.topAnchor.constraint(
                equalTo: topAnchor,
                constant: ConstantResultSearchCell.constantAnchor * 2)
        ])
        recipeImage.layer.cornerRadius =
            (frame.width - ConstantResultSearchCell.paddingRecipeImage) / 2
    }
    
    private func addContainerView() {
        addSubview(containerResultCell)
        NSLayoutConstraint.activate([
            containerResultCell.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: ConstantResultSearchCell.constantAnchor),
            containerResultCell.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -ConstantResultSearchCell.constantAnchor),
            containerResultCell.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -ConstantResultSearchCell.constantAnchor),
            containerResultCell.topAnchor.constraint(
                equalTo: topAnchor,
                constant: ConstantResultSearchCell.topView)
        ])
        containerResultCell.addShadowView(
            radius: ConstantResultSearchCell.radiusView)
        addImageView()
        addLabelMinute()
        addLabelTitle()
    }
}
