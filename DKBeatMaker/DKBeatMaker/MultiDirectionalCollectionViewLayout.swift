import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MultiDirectionalCollectionViewLayout : UICollectionViewLayout{
    let cellHeight = 60.0
    let cellWidth = 150.0
    let STATUS_BAR = UIApplication.shared.statusBarFrame.height
    
    var cellAttrsDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    var contentSize = CGSize.zero
    var dataSourceDidUpdate = true
    
    override var collectionViewContentSize : CGSize {
        return self.contentSize
    }
    
    override func prepare() {
        self.collectionView?.alwaysBounceHorizontal = false
        self.collectionView?.alwaysBounceVertical = false
        if !dataSourceDidUpdate {
            let xOffset = collectionView!.contentOffset.x
            if collectionView?.numberOfSections > 0 {
                for section in 0...collectionView!.numberOfSections-1 {
                    
                    if collectionView?.numberOfItems(inSection: section) > 0 {
                        let indexPath = IndexPath(item: 0, section: section)
                        if let attrs = cellAttrsDictionary[indexPath] {
                            var frame = attrs.frame
                            frame.origin.x = xOffset
                            attrs.frame = frame
                            
                            
                        }
                    }
                }
            }
            
            return
        }
        
        dataSourceDidUpdate = false
        var widthOfItems = Double(0)
        // Cycle through each section of the data source.
        if collectionView?.numberOfSections > 0 {
            for section in 0...collectionView!.numberOfSections-1 {
                
                // Cycle through each item in the section.
                if collectionView?.numberOfItems(inSection: section) > 0 {
                    var calculatedCellWidth = Double(0)
                    for item in 0...collectionView!.numberOfItems(inSection: section)-1 {
                        
                        // Build the UICollectionVieLayoutAttributes for the cell.
                        let cellIndex = IndexPath(item: item, section: section)
                        var xPos: Double
                        if section % 2 == 0 && section != 0 && item != 0 {
                            calculatedCellWidth = self.cellWidth * 2
                            xPos = Double(item) * calculatedCellWidth - self.cellWidth
                        }else {
                            calculatedCellWidth = self.cellWidth
                            xPos = Double(item) * calculatedCellWidth
                        }
                        let yPos = Double(section) * cellHeight
                        
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: calculatedCellWidth, height: cellHeight)
                        
                        // Determine zIndex based on cell type.
                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else if section == 0 {
                            cellAttributes.zIndex = 3
                        } else if item == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        
                        // Save the attributes.
                        cellAttrsDictionary[cellIndex] = cellAttributes
                        
                    }
                    let currentWidth = Double(collectionView!.numberOfItems(inSection: section)) * calculatedCellWidth
                    if !(widthOfItems > currentWidth) {
                        widthOfItems = currentWidth
                    }

                }
                
            }
        }
        
        // Update content size.
        let contentWidth = widthOfItems
        let contentHeight = Double(collectionView!.numberOfSections) * cellHeight
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrsDictionary.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        
        // Return list of elements.
        return attributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]!
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
