import UIKit
import AudioKit

class ViewController: UIViewController, CAAnimationDelegate {
    
    @IBOutlet weak var synthTapped: UIBarButtonItem!
    @IBOutlet weak var pauseTapped: UIBarButtonItem!
    @IBOutlet weak var playTapped: UIBarButtonItem!
    
    // grid object
    let line: CAShapeLayer = CAShapeLayer()
    var blocks: Array<SeqMidiNote> = Array<SeqMidiNote>()
    var gridDictionary: [String:CALayer] = [String:CALayer]()
    
    var beatGrid: Float = (1.0/4.0)
    var noOfBars: Float  = 1.0
    let noOfNotesInAnOctave: Int = 12
    
    var midiNotesHighlighted: Array<SeqMidiNote> = Array<SeqMidiNote>()
    var midi: AKMIDI = AKMIDI()
    let conductor: Conductor = Conductor()
    let lineAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
    
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
        
        line.path = UIBezierPath(roundedRect: CGRect(x: 0 , y: 5, width: 1, height: self.view.frame.size.height),
                                 cornerRadius: 0).cgPath
        line.backgroundColor = UIColor(red: 0.61, green: 0.62, blue: 0.68, alpha: 1.0).cgColor
        line.strokeColor = UIColor(red: 0.61, green: 0.62, blue: 0.68, alpha: 1.0).cgColor
        line.lineWidth = 1.0
        self.animationView.layer.addSublayer(line)
        
//        fadeAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        self.lineAnimation.fromValue = 1.0
        self.lineAnimation.toValue = self.view.frame.size.width
        self.lineAnimation.duration = 2
        self.lineAnimation.repeatCount = Float(Int.max)
        self.lineAnimation.delegate = self
        conductor.generateNewMelodicSequence(self.midiNotesHighlighted)
        
        self.gridChangeButton.setTitle(self.displayLabelForGridButton(self.beatGrid), for: UIControlState())
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
        self.animationView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let tappedPoint: CGPoint = gestureRecognizer.location(in: self.gridVIew)
        
        for i: Int in 0..<self.blocks.count {
            if(blocks[i].rect.contains(tappedPoint)){
                if self.blocks[i].isSelected {
                    self.removeMidiNote(blocks[i])
                } else {
                    self.midiNotesHighlighted.append(blocks[i])
                }
                blocks[i].isSelected = !blocks[i].isSelected
                blocks[i].noteColor = blocks[i].isSelected ? UIColor(red:0.15, green:0.17, blue:0.29, alpha:1.0).cgColor :
                                                             UIColor(red:0.35, green:0.36, blue:0.47, alpha:1.0).cgColor
                
                let layer:CAShapeLayer = CAShapeLayer()
                layer.path = UIBezierPath(roundedRect: blocks[i].rect, cornerRadius: 0).cgPath
                layer.fillColor = blocks[i].noteColor
                layer.lineWidth = 1.0
                layer.strokeColor = UIColor(red:0.61, green:0.62, blue:0.68, alpha:1.0).cgColor
                self.notesView.layer.addSublayer(layer)
                
                break
            }
        }
        self.conductor.generateNewMelodicSequence(self.midiNotesHighlighted)
        view.setNeedsLayout()
    }
    
    func removeMidiNote(_ midiNote: SeqMidiNote) {
        for i: Int in 0..<self.midiNotesHighlighted.count {
            if midiNote.rect.contains(self.midiNotesHighlighted[i].rect.origin){
                self.midiNotesHighlighted.remove(at: i)
                break
            }
        }
    }
    
    func createGridLayer(_ grid: Float) -> CALayer {
        let gridLayer: CAShapeLayer = CAShapeLayer()
        let noBlocks: Float = self.noOfBars / grid
        let blockHight: CGFloat = self.view.bounds.size.height / CGFloat(noOfNotesInAnOctave)
        let blockWidth: CGFloat = self.view.bounds.size.width / CGFloat(noBlocks)
        
        for row: Int in 0..<Int(noBlocks){
            for col: Int in 0..<noOfNotesInAnOctave {
                let rect = CGRect(x: CGFloat(CGFloat(row)*blockWidth),y: (CGFloat(col)*CGFloat(blockHight)),width: blockWidth,height: blockHight)
                let layer = CAShapeLayer()
                layer.path = UIBezierPath(roundedRect: rect, cornerRadius: 0).cgPath
                layer.fillColor = UIColor(red:0.35, green:0.36, blue:0.47, alpha:1.0).cgColor
                layer.lineWidth = 1.0
                layer.strokeColor = UIColor(red:0.61, green:0.62, blue:0.68, alpha:1.0).cgColor
                gridLayer.addSublayer(layer)
            }
        }
        return gridLayer
    }
    
    func shouldAddNote(_ origiin: CGPoint) -> SeqMidiNote? {
        for i: Int in 0..<self.blocks.count{
            if(origiin.equalTo(blocks[i].rect.origin)){
                return self.blocks[i]
            }
        }
        return nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func gridChangeTapped(_ sender: AnyObject) {
        self.beatGrid /= 2.0;
        
        if(self.beatGrid == 1/32) {
            self.beatGrid = 1/4
        }
        self.gridVIew.layer.sublayers?.removeAll()
        self.gridVIew.layer.addSublayer(self.gridDictionary[self.displayLabelForGridButton(self.beatGrid)]!)
        self.gridChangeButton.setTitle(self.displayLabelForGridButton(self.beatGrid), for: UIControlState())
        self.blocks = self.updateBlocks(self.beatGrid)
        view.layoutIfNeeded()
    }
    
    func displayLabelForGridButton(_ lBeatGrid: Float) -> String {
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
    
    func updateBlocks(_ breaGrid: Float) -> Array<SeqMidiNote> {
        self.blocks.removeAll()
        let noBlocks: Float = self.noOfBars / beatGrid
        let blockHight: CGFloat = self.view.bounds.size.height / CGFloat( noOfNotesInAnOctave)
        let blockWidth: CGFloat = self.view.bounds.size.width / CGFloat( noBlocks)
        
        for row: Int in 0..<Int(noBlocks){
            for col: Int in 0..<noOfNotesInAnOctave {
                let rect: CGRect = CGRect(x: CGFloat(CGFloat(row)*blockWidth),
                                              y: (CGFloat(col) * CGFloat(blockHight)),
                                              width: blockWidth,
                                              height: blockHight)
                let block: SeqMidiNote = SeqMidiNote(rect: rect,
                                                     noteColor: UIColor(red:0.35, green:0.36, blue:0.47, alpha:1.0).cgColor,
                                                     noteValue: col,
                                                     notePosition: Float(row)/noBlocks)
                self.blocks.append(block)
            }
        }
        return self.blocks
    }
    
    @IBAction func pausedTapped(_ sender: AnyObject) {
        line.removeAnimation(forKey: "transform.translation.y")
        self.conductor.stopPlaying()
    }
    
    @IBAction func playTapped(_ sender: AnyObject) {
        line.add(self.lineAnimation, forKey: "transform.translation.y")
        self.conductor.startPlaying()
    }
        
    @IBAction func synthTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "synthSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let synthVC = segue.destination as! SynthViewController
            synthVC.configureWithConductor(self.conductor)
    }
}
