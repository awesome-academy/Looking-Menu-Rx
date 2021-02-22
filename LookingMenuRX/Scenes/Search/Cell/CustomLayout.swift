import Foundation
import UIKit

protocol CustomSearchDelegate: class {
    func collectionView(_ collectionView: UICollectionView,
                        sizeRecipeItem indexPath : IndexPath) -> CGSize
}

class CustomSearchCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: CustomSearchDelegate!
    
    var numberOfColumns = 2
    var cellPadding: CGFloat = 3
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        return collectionView?.bounds.width ?? 0
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth,
                      height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffest = [CGFloat]()
        for column in 0..<numberOfColumns {
            xOffest.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset = [CGFloat]()
        
        for column in 0..<numberOfColumns {
            yOffset.append(column % 2 == 0 ? 0 : 50)
        }
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let recipeSize = delegate.collectionView(collectionView, sizeRecipeItem: indexPath)
            
            let cellWidth = columnWidth
            var cellHeight = recipeSize.height
            
            cellHeight = cellPadding * 2 + cellHeight
            
            let frame = CGRect(x: xOffest[column], y: yOffset[column], width: cellWidth, height: cellHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + cellHeight
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        if collectionView?.numberOfItems(inSection: 0) != 0 {
            for attributes in cache {
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

