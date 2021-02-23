import UIKit
import Reusable
import SDWebImage
import Then

private enum ConstantFavouriteRecipeCell {
    static let fontSizeTitle = 16
    static let fontSizeMinuteCooking = 18
    static let constantAnchor: CGFloat = 8
    static let radiusView: CGFloat = 10
    static let sizeImageRecipeFavourite: CGFloat = 70
}

final class FavouriteRecipeTableCell: UITableViewCell, Reusable {
    lazy private var favouriteRecipeBackground = UIView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy private var favouriteRecipeImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy private var favouriteRecipeTitleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.setUpLabelCell(fontSize: ConstantFavouriteRecipeCell.fontSizeTitle)
    }
    
    lazy private var favouriteRecipeMinuteCookingLabel = UILabel().then {
        $0.textColor = .redDesign
        $0.setUpLabelCell(fontSize: ConstantFavouriteRecipeCell.fontSizeMinuteCooking)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBackGroundRecipeFavourite()
    }
    
    func configFavouriteRecipeCell(item: Recipe) {
        favouriteRecipeImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        favouriteRecipeImageView.sd_setImage(with: URL(string: item.image), completed: nil)
        favouriteRecipeTitleLabel.text = item.title
        favouriteRecipeMinuteCookingLabel.text = "\(item.readyInMinutes) Minute"
    }
    
    private func addBackGroundRecipeFavourite() {
        addSubview(favouriteRecipeBackground)
        
        NSLayoutConstraint.activate([
            favouriteRecipeBackground.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeBackground.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeBackground.topAnchor.constraint(
                equalTo: topAnchor,
                constant: ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeBackground.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -ConstantFavouriteRecipeCell.constantAnchor)
        ])
        
        favouriteRecipeBackground.layer.cornerRadius = ConstantFavouriteRecipeCell.radiusView
        favouriteRecipeBackground.addShadowView(radius: ConstantFavouriteRecipeCell.radiusView)
        
        backgroundColor = .systemGray6
        addImageRecipeFavourite()
        addTitleLabelRecipeFavourite()
        addMinuteCookingLabelRecipeFavourite()
    }
    
    private func addImageRecipeFavourite() {
        favouriteRecipeBackground.addSubview(favouriteRecipeImageView)
        
        NSLayoutConstraint.activate([
            favouriteRecipeImageView.leadingAnchor.constraint(
                equalTo: favouriteRecipeBackground.leadingAnchor,
                constant: ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            favouriteRecipeImageView.heightAnchor.constraint(
                equalToConstant: ConstantFavouriteRecipeCell.sizeImageRecipeFavourite),
            favouriteRecipeImageView.widthAnchor.constraint(
                equalToConstant: ConstantFavouriteRecipeCell.sizeImageRecipeFavourite)
        ])

        favouriteRecipeImageView.cornerCircle()
    }
    
    private func addTitleLabelRecipeFavourite() {
        favouriteRecipeBackground.addSubview(favouriteRecipeTitleLabel)
        
        NSLayoutConstraint.activate([
            favouriteRecipeTitleLabel.leadingAnchor.constraint(
                equalTo: favouriteRecipeImageView.trailingAnchor,
                constant: ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeTitleLabel.trailingAnchor.constraint(
                equalTo: favouriteRecipeBackground.trailingAnchor,
                constant: -ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeTitleLabel.topAnchor.constraint(
                equalTo: favouriteRecipeImageView.topAnchor)
        ])
    }
    
    private func addMinuteCookingLabelRecipeFavourite() {
        favouriteRecipeBackground.addSubview(favouriteRecipeMinuteCookingLabel)
        
        NSLayoutConstraint.activate([
            favouriteRecipeMinuteCookingLabel.leadingAnchor.constraint(
                equalTo: favouriteRecipeImageView.trailingAnchor,
                constant: ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeMinuteCookingLabel.trailingAnchor.constraint(
                equalTo: favouriteRecipeBackground.trailingAnchor,
                constant: -ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeMinuteCookingLabel.bottomAnchor.constraint(
                equalTo: favouriteRecipeImageView.bottomAnchor)
        ])
    }
}
