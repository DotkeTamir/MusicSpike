import UIKit

@IBDesignable
class AudioControllerCell: UICollectionViewCell {
    
    var trackNumber: Int = 1000000
    var delegate: AddClipDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        
    }
    
    @IBAction func addClipTapped(sender: AnyObject) {
        delegate?.addClipForTrackNumber(self.trackNumber)
    }
}
