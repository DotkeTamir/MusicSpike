import UIKit

class MultiDirectionalCollectionViewLayout : UICollectionViewLayout{
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
        // Only update header cells.
        if !dataSourceDidUpdate {
            // Determine current content offsets.
            let xOffset = collectionView!.contentOffset.x
//            let yOffset = collectionView!.contentOffset.y
            
            if collectionView?.numberOfSections() > 0 {
                for section in 0...collectionView!.numberOfSections()-1 {
                    
                    // Confirm the section has items.
                    if collectionView?.numberOfItemsInSection(section) > 0 {
                        
                        // Update all items in the first row.
                        
                        
                        // Build indexPath to get attributes from dictionary.
                        let indexPath = NSIndexPath(forItem: 0, inSection: section)
                        
                        // Update y-position to follow user.
                        if let attrs = cellAttrsDictionary[indexPath] {
                            var frame = attrs.frame
                            frame.origin.x = xOffset
                            attrs.frame = frame
                            
                            
                        } // else
                    } // num of items in section > 0
                } // sections for loop
            } // num of sections > 0
            
            
            // Do not run attribute generation code
            // unless data source has been updated.
            return
        }
        
        // Acknowledge data source change, and disable for next time.
        dataSourceDidUpdate = false
        
        // Cycle through each section of the data source.
        if collectionView?.numberOfSections() > 0 {
            for section in 0...collectionView!.numberOfSections()-1 {
                
                // Cycle through each item in the section.
                if collectionView?.numberOfItemsInSection(section) > 0 {
                    for item in 0...collectionView!.numberOfItemsInSection(section)-1 {
                        
                        // Build the UICollectionVieLayoutAttributes for the cell.
                        let cellIndex = NSIndexPath(forItem: item, inSection: section)
                        var calculatedCellWidth: Double
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
                }
                
            }
        }
        
        // Update content size.
        let contentWidth = Double(collectionView!.numberOfItemsInSection(0)) * cellWidth
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
