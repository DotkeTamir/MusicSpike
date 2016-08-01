import UIKit
import AudioKit

class ViewController: UIViewController {
    
    var beatGrid : Float = (1/4)
    var noOfBars  = 1
    let noOfNotesInAnOctave = 12
    var blocks: Array<MidiNoteBlock> = Array<MidiNoteBlock>()
    
    var gridDictionary = [String: CALayer]()

    var midi  = AKMIDI()
    
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var gridVIew: UIView!
    @IBOutlet weak var gridChangeButton: UIButton!
    @IBOutlet weak var animationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.blocks = self.layerToDraw()
        self.gridDictionary["1/4"] = self.createGridLayer(0.25)
        self.gridDictionary["1/8"] = self.createGridLayer(0.125)
        self.gridDictionary["1/16"] = self.createGridLayer(0.0625)
        self.gridVIew.layer.addSublayer(self.gridDictionary["1/4"]!)
        
        let line = CAShapeLayer()
        line.path = UIBezierPath(roundedRect: CGRect(x: 0 , y: 5, width: self.view.bounds.size.width, height: 1), cornerRadius: 0).CGPath
        line.backgroundColor = UIColor.yellowColor().CGColor
        line.strokeColor = UIColor.whiteColor().CGColor
        line.lineWidth = 1.0
        self.animationView.layer.addSublayer(line)
        
        
        
        let fadeAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = self.view.frame.size.height
        fadeAnimation.duration = 2
        fadeAnimation.repeatCount = Float(Int.max)
        
        line.addAnimation(fadeAnimation, forKey: "transform.translation.y")
        
        self.gridChangeButton.setTitle(self.displayLabelForGridButton(self.beatGrid), forState: UIControlState.Normal)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        self.animationView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let tappedPoint = gestureRecognizer.locationInView(self.gridVIew)
        
        for i in 0..<self.blocks.count {
            if(CGRectContainsPoint(blocks[i].rect, tappedPoint)){
                blocks[i].isSelected = !blocks[i].isSelected
                blocks[i].noteColor = blocks[i].isSelected ? UIColor.greenColor().CGColor : UIColor.blackColor().CGColor
                let layer = CAShapeLayer()
                //                let block = blocks[i]
                layer.path = UIBezierPath(roundedRect: blocks[i].rect, cornerRadius: 0).CGPath
                layer.fillColor = blocks[i].noteColor
                layer.lineWidth = 1.0
                layer.strokeColor = UIColor.redColor().CGColor
                self.notesView.layer.addSublayer(layer)

                break
            }
        }
        view.setNeedsLayout()
    }
    
//    func layerToDraw() -> Array<MidiNoteBlock> {
//        var blocks: Array<MidiNoteBlock> = Array<MidiNoteBlock>()
//        let noBlocks = Float(self.noOfBars) / self.beatGrid
//        let blockHight = self.view.bounds.size.width / CGFloat( noOfNotesInAnOctave)
//        let blockWidth = self.view.bounds.size.height / CGFloat( noBlocks)
//        
//        for row in 0..<noOfNotesInAnOctave{
//            for col in 0..<Int(noBlocks) {
//                let rect = CGRectMake(CGFloat(CGFloat(row)*blockHight),(CGFloat(col)*CGFloat(blockWidth)),blockHight,blockWidth)
//                let block = MidiNoteBlock(rect: rect, noteColor: UIColor.blackColor().CGColor)
//                let someBlock = self.shouldAddNote(rect.origin)
//                if(someBlock == nil){
//                    blocks.append(block)
//                }
//            }
//        }
//        self.blocks.appendContentsOf(blocks)
//        return self.blocks
//    }
    
    func createGridLayer(grid: Float) -> CALayer {
        
        let gridLayer = CAShapeLayer()
        let noBlocks = Float(self.noOfBars) / grid
        let blockHight = self.view.bounds.size.width / CGFloat( noOfNotesInAnOctave)
        let blockWidth = self.view.bounds.size.height / CGFloat( noBlocks)
        
        for row in 0..<noOfNotesInAnOctave{
            for col in 0..<Int(noBlocks) {
                let rect = CGRectMake(CGFloat(CGFloat(row)*blockHight),(CGFloat(col)*CGFloat(blockWidth)),blockHight,blockWidth)
                let block = MidiNoteBlock(rect: rect, noteColor: UIColor.blackColor().CGColor)
                let someBlock = self.shouldAddNote(rect.origin)
                if(someBlock == nil){
                    blocks.append(block)
                }
                
                let layer = CAShapeLayer()
//                let block = blocks[i]
                layer.path = UIBezierPath(roundedRect: rect, cornerRadius: 0).CGPath
                layer.fillColor = block.noteColor
                layer.lineWidth = 1.0
                layer.strokeColor = UIColor.redColor().CGColor
                gridLayer.addSublayer(layer)

            }
        }
        return gridLayer
    }

    
    func shouldAddNote(origiin: CGPoint) ->  MidiNoteBlock? {
        for i in 0..<self.blocks.count{
            if(CGPointEqualToPoint(origiin, blocks[i].rect.origin)){
                return self.blocks[i]
            }
        }
        return nil
    }
    override func viewWillLayoutSubviews() {
////        self.gridVIew.layer.sublayers?.removeAll()
//
//        for i in 0..<blocks.count {
//            let layer = CAShapeLayer()
//            let block = blocks[i]
//            layer.path = UIBezierPath(roundedRect: block.rect, cornerRadius: 0).CGPath
//            layer.fillColor = block.noteColor
//            layer.lineWidth = 1.0
//            layer.strokeColor = UIColor.redColor().CGColor
//          self.gridVIew.layer.addSublayer(layer)
//    
//        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func gridChangeTapped(sender: AnyObject) {
        self.beatGrid /= 2;
        
        if(self.beatGrid == 1/32){
            self.beatGrid = 1/4
            self.blocks.removeAll()
        }
        self.gridVIew.layer.sublayers?.removeAll()
        self.gridVIew.layer.addSublayer(self.gridDictionary[self.displayLabelForGridButton(self.beatGrid)]!)
        self.gridChangeButton.setTitle(self.displayLabelForGridButton(self.beatGrid), forState: UIControlState.Normal)
//        self.blocks = self.layerToDraw()
        view.layoutIfNeeded()
    }
    
    func displayLabelForGridButton(lBeatGrid: Float) -> String {
        if(lBeatGrid == 1){
            return "1"
        } else if(lBeatGrid == (1/2)){
            return "1/2"
        }else if(lBeatGrid == (1/4)){
            return "1/4"
        }else if(lBeatGrid == (1/8)){
            return "1/8"
        }else if(lBeatGrid == (1/16)){
            return "1/16"
        }else if(lBeatGrid == (1/32)){
            return "1/32"
        }
        return ""
    }
}