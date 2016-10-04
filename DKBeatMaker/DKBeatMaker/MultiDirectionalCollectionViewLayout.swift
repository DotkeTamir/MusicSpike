import UIKit

class MultiDirectionalCollectionViewLayout : UICollectionViewFlowLayout{
    let cellHeight = 60.0
    let cellWidth = 150.0
    let STATUS_BAR = UIApplication.sharedApplication().statusBarFrame.height
    
    var cellAttrsDictionary = Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>()
    var contentSize = CGSize.zero
    var dataSourceDidUpdate = true
    
    override func collectionViewContentSize() -> CGSize {
        return self.contentSize
    }
    
    override func prepareLayout() {
        self.collectionView?.alwaysBounceHorizontal = false
        self.collectionView?.alwaysBounceVertical = false
        if !dataSourceDidUpdate {
            let xOffset = collectionView!.contentOffset.x
            if collectionView?.numberOfSections() > 0 {
                for section in 0...collectionView!.numberOfSections()-1 {
                    
                    if collectionView?.numberOfItemsInSection(section) > 0 {
                        let indexPath = NSIndexPath(forItem: 0, inSection: section)
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
        if collectionView?.numberOfSections() > 0 {
            for section in 0...collectionView!.numberOfSections()-1 {
                
                // Cycle through each item in the section.
                if collectionView?.numberOfItemsInSection(section) > 0 {
                    var calculatedCellWidth = Double(0)
                    for item in 0...collectionView!.numberOfItemsInSection(section)-1 {
                        
                        // Build the UICollectionVieLayoutAttributes for the cell.
                        let cellIndex = NSIndexPath(forItem: item, inSection: section)
                        var xPos: Double
                        if section % 2 == 0 && section != 0 && item != 0 {
                            calculatedCellWidth = self.cellWidth * 2
                            xPos = Double(item) * calculatedCellWidth - self.cellWidth
                        }else {
                            calculatedCellWidth = self.cellWidth
                            xPos = Double(item) * calculatedCellWidth
                        }
                        let yPos = Double(section) * cellHeight
                        
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: cellIndex)
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
                    let currentWidth = Double(collectionView!.numberOfItemsInSection(section)) * calculatedCellWidth
                    if !(widthOfItems > currentWidth) {
                        widthOfItems = currentWidth
                    }

                }
                
            }
        }
        
        // Update content size.
        let contentWidth = widthOfItems
        let contentHeight = Double(collectionView!.numberOfSections()) * cellHeight
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrsDictionary.values {
            if CGRectIntersectsRect(rect, cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        
        // Return list of elements.
        return attributesInRect
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]!
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
}
