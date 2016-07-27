import UIKit

class ViewController: UIViewController {
    
    var beatGrid : Float = (1/4)
    var noOfBars  = 1
    let noOfNotesInAnOctave = 12
    
    @IBOutlet weak var gridVIew: UIView!
    @IBOutlet weak var gridChangeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
//        UIDevice.currentDevice().setValue(value, forKey: "orientation")
//        UIViewController.attemptRotationToDeviceOrientation()
        
        let blocks = self.layerToDraw()
        
        for i in 0..<blocks.count {
            let layer = CAShapeLayer()
            let block = blocks[i]
            layer.path = UIBezierPath(roundedRect: block.rect, cornerRadius: 0).CGPath
            layer.backgroundColor = UIColor.blueColor().CGColor
            layer.lineWidth = 1.0
            layer.strokeColor = UIColor.redColor().CGColor
            self.gridVIew.layer.addSublayer(layer)
        }
        let line = CAShapeLayer()
        line.path = UIBezierPath(roundedRect: CGRect(x: 0 , y: 5, width: self.view.bounds.size.width, height: 1), cornerRadius: 0).CGPath
        line.backgroundColor = UIColor.yellowColor().CGColor
        line.strokeColor = UIColor.whiteColor().CGColor
        line.lineWidth = 1.0
        self.gridVIew.layer.addSublayer(line)
        
        
        let fadeAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = self.view.bounds.size.width
        fadeAnimation.duration = 2
        fadeAnimation.repeatCount = Float(Int.max)
        
        line.addAnimation(fadeAnimation, forKey: "transform.translation.y")
        
        self.gridChangeButton.setTitle(String(beatGrid), forState: UIControlState.Normal)
    }
    
    func layerToDraw() -> Array<MidiNoteBlock> {
        var blocks: Array<MidiNoteBlock> = Array<MidiNoteBlock>()
        let noBlocks = Float(self.noOfBars) / self.beatGrid
        let blockHight = self.view.frame.size.width / CGFloat( noOfNotesInAnOctave)
        let blockWidth = self.view.frame.size.height / CGFloat( noBlocks)
        
        for row in 0..<noOfNotesInAnOctave{
            for col in 0..<Int(noBlocks) {
                let rect = CGRectMake(CGFloat(CGFloat(row)*blockHight),(CGFloat(col)*CGFloat(blockWidth)),blockHight,blockWidth)
                let block = MidiNoteBlock(rect: rect)
                blocks.append(block)
                
            }
        }
        return blocks;
    }
    
//    override func viewWillLayoutSubviews() {
//        self.gridVIew.layer.sublayers?.removeAll()
//        let blocks = self.layerToDraw()
//        
//        for i in 0..<blocks.count {
//            let layer = CAShapeLayer()
//            let block = blocks[i]
//            layer.path = UIBezierPath(roundedRect: block.rect, cornerRadius: 0).CGPath
//            layer.backgroundColor = UIColor.blueColor().CGColor
//            layer.lineWidth = 1.0
//            layer.strokeColor = UIColor.redColor().CGColor
//            self.gridVIew.layer.addSublayer(layer)
//        }
//
//    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.LandscapeLeft
//    }
//    
    @IBAction func gridChangeTapped(sender: AnyObject) {
        beatGrid /= 2;
        self.gridChangeButton.setTitle(String(beatGrid), forState: UIControlState.Normal)
        view.layoutIfNeeded()
    }
//    
//    override func shouldAutorotate() -> Bool {
//        return true
//    }
}