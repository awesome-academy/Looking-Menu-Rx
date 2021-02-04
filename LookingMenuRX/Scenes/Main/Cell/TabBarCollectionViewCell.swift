import UIKit
import Reusable
import Then

private enum ConstantTabBarCell: CGFloat {
    case sizeTabBarLabel = 13
    case spaceTabBarBackground = 20
    case sizeTabBarIcon = 35
    case spaceTabBarIcon = 5
}

final class TabBarCollectionViewCell: UICollectionViewCell, Reusable {
    private var constraintCenterHorizontalIcon: NSLayoutConstraint?
    private var constraintLeadingIcon: NSLayoutConstraint?
    
    private lazy var tabBarIcon = UIImageView().then {
        $0.tintColor = .grayDesign
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var tabBarLabel = UILabel().then {
        $0.textColor = .grayDesign
        $0.font = UIFont.boldSystemFont(ofSize: ConstantTabBarCell.sizeTabBarLabel.rawValue)
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var tabBarViewBackground = UIView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViewBackgroundToTabbar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configCell(name: String) {
        if let image = UIImage(named: name) {
            tabBarIcon.image = image.withRenderingMode(.alwaysTemplate)
            tabBarLabel.text = name
        }
    }
    
    override var isSelected: Bool {
        didSet {
            let red = UIColor.redDesign
            let gray = UIColor.grayDesign
            tabBarViewBackground.backgroundColor = isSelected ?
                red.withAlphaComponent(0.4) : .white
            
            if let horizontalIcon = constraintCenterHorizontalIcon,
               let leftIcon = constraintLeadingIcon {
                horizontalIcon.isActive = !isSelected
                leftIcon.isActive = isSelected
            }
            
            tabBarIcon.tintColor = isSelected ? red : gray
            tabBarLabel.textColor = isSelected ? red : gray
            tabBarLabel.isHidden = !isSelected
            animationIconItemTabBarSelected()
        }
    }
    
    private func animationIconItemTabBarSelected() {
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    private func addViewBackgroundToTabbar() {
        addSubview(tabBarViewBackground)
        tabBarViewBackground.contentHuggingPriority(for: .horizontal)
        NSLayoutConstraint.activate([
            tabBarViewBackground.topAnchor.constraint(
                equalTo: topAnchor,
                constant: ConstantTabBarCell.spaceTabBarBackground.rawValue),
            tabBarViewBackground.widthAnchor.constraint(
                equalToConstant: frame.width),
            tabBarViewBackground.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -ConstantTabBarCell.spaceTabBarBackground.rawValue)
        ])
        tabBarViewBackground.layer.cornerRadius =
            (frame.height - (ConstantTabBarCell.spaceTabBarBackground.rawValue * 2)) / 2
        
        addIconTotabBarViewBackground()
        addLabelTotabBarViewBackground()
    }
    
    private func addLabelTotabBarViewBackground() {
        tabBarViewBackground.addSubview(tabBarLabel)
        NSLayoutConstraint.activate([
            tabBarLabel.leadingAnchor.constraint(
                equalTo: tabBarIcon.trailingAnchor,
                constant: ConstantTabBarCell.spaceTabBarIcon.rawValue),
            tabBarLabel.trailingAnchor.constraint(
                equalTo: tabBarViewBackground.trailingAnchor),
            tabBarLabel.centerYAnchor.constraint(
                equalTo: tabBarIcon.centerYAnchor)
        ])
        tabBarLabel.isHidden = true
    }
    
    private func addIconTotabBarViewBackground() {
        tabBarViewBackground.addSubview(tabBarIcon)
        constraintLeadingIcon = tabBarIcon.leadingAnchor.constraint(
            equalTo: tabBarViewBackground.leadingAnchor,
            constant: ConstantTabBarCell.spaceTabBarIcon.rawValue)
        constraintCenterHorizontalIcon = tabBarIcon.centerXAnchor.constraint(
            equalTo: centerXAnchor)
        
        if let horizontalIcon = constraintCenterHorizontalIcon,
           let leftIcon = constraintLeadingIcon {
            horizontalIcon.isActive = true
            leftIcon.isActive = false
        }
        
        NSLayoutConstraint.activate([
            tabBarIcon.widthAnchor.constraint(
                equalToConstant: ConstantTabBarCell.sizeTabBarIcon.rawValue),
            tabBarIcon.heightAnchor.constraint(
                equalToConstant: ConstantTabBarCell.sizeTabBarIcon.rawValue),
            tabBarIcon.centerYAnchor.constraint(
                equalTo: tabBarViewBackground.centerYAnchor)
        ])
    }
}
