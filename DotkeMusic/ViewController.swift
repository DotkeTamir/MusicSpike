import UIKit
import AudioKit

class ViewController: UIViewController {
    
    var beatGrid : Float = (1/4)
    var noOfBars  = 1
    let noOfNotesInAnOctave = 12
    var blocks: Array<MidiNoteBlock> = Array<MidiNoteBlock>()

    var midi  = AKMIDI()
    
    @IBOutlet weak var gridVIew: UIView!
    @IBOutlet weak var gridChangeButton: UIButton!
    @IBOutlet weak var animationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blocks = self.layerToDraw()

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
                blocks[i].noteColor = UIColor.greenColor().CGColor
                break
            }
        }
        view.setNeedsLayout()
    }
    
    func layerToDraw() -> Array<MidiNoteBlock> {
        var blocks: Array<MidiNoteBlock> = Array<MidiNoteBlock>()
        let noBlocks = Float(self.noOfBars) / self.beatGrid
        let blockHight = self.view.bounds.size.width / CGFloat( noOfNotesInAnOctave)
        let blockWidth = self.view.bounds.size.height / CGFloat( noBlocks)
        
        for row in 0..<noOfNotesInAnOctave{
            for col in 0..<Int(noBlocks) {
                let rect = CGRectMake(CGFloat(CGFloat(row)*blockHight),(CGFloat(col)*CGFloat(blockWidth)),blockHight,blockWidth)
                let block = MidiNoteBlock(rect: rect, noteColor: UIColor.blackColor().CGColor)
                blocks.append(block)
                
            }
        }
        return blocks;
    }
    
    override func viewWillLayoutSubviews() {
        self.gridVIew.layer.sublayers?.removeAll()
        if(self.blocks.count == 0){
//            self.blocks = self.layerToDraw()
        }
        
        for i in 0..<blocks.count {
            let layer = CAShapeLayer()
            let block = blocks[i]
            layer.path = UIBezierPath(roundedRect: block.rect, cornerRadius: 0).CGPath
            layer.fillColor = block.noteColor
            layer.lineWidth = 1.0
            layer.strokeColor = UIColor.redColor().CGColor
          self.gridVIew.layer.addSublayer(layer)
    
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func gridChangeTapped(sender: AnyObject) {
        self.beatGrid /= 2;
        
        if(self.beatGrid == 1/64){
            self.beatGrid = 1
        }
        self.gridChangeButton.setTitle(self.displayLabelForGridButton(self.beatGrid), forState: UIControlState.Normal)
        self.blocks = self.layerToDraw()
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