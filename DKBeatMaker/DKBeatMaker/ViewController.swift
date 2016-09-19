import UIKit
import AudioKit

class ViewController: UIViewController {
    
    @IBOutlet weak var synthTapped: UIBarButtonItem!
    
    @IBOutlet weak var pauseTapped: UIBarButtonItem!
    @IBOutlet weak var playTapped: UIBarButtonItem!
    
    // grid object
    let line = CAShapeLayer()
    var blocks: Array<SeqMidiNote> = Array<SeqMidiNote>()
    var gridDictionary = [String: CALayer]()
    
    var beatGrid : Float = (1/4)
    var noOfBars  = 1
    let noOfNotesInAnOctave = 12
    
    var midiNotesHighlighted: Array<SeqMidiNote> = Array<SeqMidiNote>()
    var midi  = AKMIDI()
    let conductor = Conductor()
    let lineAnimation = CABasicAnimation(keyPath: "transform.translation.x")
    
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var gridVIew: UIView!
    @IBOutlet weak var gridChangeButton: UIButton!
    @IBOutlet weak var animationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gridDictionary["1/4"] = self.createGridLayer(0.25)
        self.gridDictionary["1/8"] = self.createGridLayer(0.125)
        self.gridDictionary["1/16"] = self.createGridLayer(0.0625)
        self.gridVIew.layer.addSublayer(self.gridDictionary["1/4"]!)
        self.blocks = self.updateBlocks(self.beatGrid)
        
        line.path = UIBezierPath(roundedRect: CGRect(x: 0 , y: 5, width: 1, height: self.view.frame.size.height), cornerRadius: 0).CGPath
        line.backgroundColor = UIColor(red:0.61, green:0.62, blue:0.68, alpha:1.0).CGColor
        line.strokeColor = UIColor(red:0.61, green:0.62, blue:0.68, alpha:1.0).CGColor
        line.lineWidth = 1.0
        self.animationView.layer.addSublayer(line)
        
        
        
//        fadeAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        self.lineAnimation.fromValue = 1.0
        self.lineAnimation.toValue = self.view.frame.size.width
        self.lineAnimation.duration = 2
        self.lineAnimation.repeatCount = Float(Int.max)
        self.lineAnimation.delegate = self
        conductor.generateNewMelodicSequence(self.midiNotesHighlighted)
        
        self.gridChangeButton.setTitle(self.displayLabelForGridButton(self.beatGrid), forState: UIControlState.Normal)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
        self.animationView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let tappedPoint = gestureRecognizer.locationInView(self.gridVIew)
        
        for i in 0..<self.blocks.count {
            if(CGRectContainsPoint(blocks[i].rect, tappedPoint)){
                
                if self.blocks[i].isSelected {
                    self.removeMidiNote(blocks[i])
                } else {
                    self.midiNotesHighlighted.append(blocks[i])
                }
                blocks[i].isSelected = !blocks[i].isSelected
                blocks[i].noteColor = blocks[i].isSelected ? UIColor(red:0.15, green:0.17, blue:0.29, alpha:1.0).CGColor : UIColor(red:0.35, green:0.36, blue:0.47, alpha:1.0).CGColor
                
                
                
                let layer = CAShapeLayer()
                layer.path = UIBezierPath(roundedRect: blocks[i].rect, cornerRadius: 0).CGPath
                layer.fillColor = blocks[i].noteColor
                layer.lineWidth = 1.0
                layer.strokeColor = UIColor(red:0.61, green:0.62, blue:0.68, alpha:1.0).CGColor
                self.notesView.layer.addSublayer(layer)
                
                break
            }
        }
        self.conductor.generateNewMelodicSequence(self.midiNotesHighlighted)
        view.setNeedsLayout()
    }
    
    func removeMidiNote(midiNote: SeqMidiNote) {
        for i in 0..<self.midiNotesHighlighted.count {
            if CGRectContainsPoint(midiNote.rect, self.midiNotesHighlighted[i].rect.origin){
                self.midiNotesHighlighted.removeAtIndex(i)
                break
            }
        }
    }
    
    func createGridLayer(grid: Float) -> CALayer {
        
        let gridLayer = CAShapeLayer()
        let noBlocks = Float(self.noOfBars) / grid
        let blockHight = self.view.bounds.size.height / CGFloat( noOfNotesInAnOctave)
        let blockWidth = self.view.bounds.size.width / CGFloat( noBlocks)
        
        for row in 0..<Int(noBlocks){
            for col in 0..<noOfNotesInAnOctave {
                let rect = CGRectMake(CGFloat(CGFloat(row)*blockWidth),(CGFloat(col)*CGFloat(blockHight)),blockWidth,blockHight)
                let layer = CAShapeLayer()
                layer.path = UIBezierPath(roundedRect: rect, cornerRadius: 0).CGPath
                layer.fillColor = UIColor(red:0.35, green:0.36, blue:0.47, alpha:1.0).CGColor
                layer.lineWidth = 1.0
                layer.strokeColor = UIColor(red:0.61, green:0.62, blue:0.68, alpha:1.0).CGColor
                gridLayer.addSublayer(layer)
                
            }
        }
        return gridLayer
    }
    
    
    func shouldAddNote(origiin: CGPoint) ->  SeqMidiNote? {
        for i in 0..<self.blocks.count{
            if(CGPointEqualToPoint(origiin, blocks[i].rect.origin)){
                return self.blocks[i]
            }
        }
        return nil
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func gridChangeTapped(sender: AnyObject) {
        self.beatGrid /= 2;
        
        if(self.beatGrid == 1/32){
            self.beatGrid = 1/4
        }
        self.gridVIew.layer.sublayers?.removeAll()
        self.gridVIew.layer.addSublayer(self.gridDictionary[self.displayLabelForGridButton(self.beatGrid)]!)
        self.gridChangeButton.setTitle(self.displayLabelForGridButton(self.beatGrid), forState: UIControlState.Normal)
        self.blocks = self.updateBlocks(self.beatGrid)
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
    
    func updateBlocks(breaGrid: Float) -> Array<SeqMidiNote> {
        self.blocks.removeAll()
        let noBlocks = Float(self.noOfBars) / beatGrid
        let blockHight = self.view.bounds.size.height / CGFloat( noOfNotesInAnOctave)
        let blockWidth = self.view.bounds.size.width / CGFloat( noBlocks)
        
        for row in 0..<Int(noBlocks){
            for col in 0..<noOfNotesInAnOctave {
                let rect = CGRectMake(CGFloat(CGFloat(row)*blockWidth),(CGFloat(col)*CGFloat(blockHight)),blockWidth,blockHight)
                let block = SeqMidiNote(rect: rect, noteColor: UIColor(red:0.35, green:0.36, blue:0.47, alpha:1.0).CGColor, noteValue: col, notePosition: Float(row)/noBlocks)
                self.blocks.append(block)
            }
        }
        return self.blocks
    }
    
    @IBAction func pausedTapped(sender: AnyObject) {
        line.removeAnimationForKey("transform.translation.y")
        self.conductor.stopPlaying()
    }
    
    @IBAction func playTapped(sender: AnyObject) {
        line.addAnimation(self.lineAnimation, forKey: "transform.translation.y")
        self.conductor.startPlaying()
    }
    
    @IBAction func synthTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("synthSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         let synthVC = segue.destinationViewController as! SynthViewController
            synthVC.configureWithConductor(self.conductor)
    }
}