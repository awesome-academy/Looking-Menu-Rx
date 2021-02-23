import UIKit
import Reusable
import Then

private enum ConstantDropDownCell {
    static let fontsizeTitle = 20
    static let constantAnchor: CGFloat = 8
}

final class DropDownTableCell: UITableViewCell, Reusable {
    private lazy var titleActivity = UILabel().then {
        $0.textColor = .white
        $0.setUpLabelCell(fontSize: ConstantDropDownCell.fontsizeTitle)
    }
    
    override func layoutSubviews() {
        backgroundColor = .redDesign
        addLabelTitleActivity()
    }
    
    func configCell(activity: String) {
        titleActivity.text = activity
    }
    
    private func addLabelTitleActivity() {
        addSubview(titleActivity)
        
        NSLayoutConstraint.activate([
            titleActivity.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: ConstantDropDownCell.constantAnchor),
            titleActivity.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -ConstantDropDownCell.constantAnchor),
            titleActivity.topAnchor.constraint(equalTo: topAnchor),
            titleActivity.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
