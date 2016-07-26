import UIKit

class ViewController: UIViewController {
    
    var beatGrid : Float = (1/4)
    var noOfBars  = 1
    let noOfNotesInAnOctave = 12

    override func viewDidLoad() {
        super.viewDidLoad()
        let blocks = self.layerToDraw()
        
        for i in 0..<blocks.count {
            let layer = CAShapeLayer()
            let block = blocks[i]
            layer.path = UIBezierPath(roundedRect: block.rect, cornerRadius: 0).CGPath
            layer.backgroundColor = UIColor.blueColor().CGColor
            layer.lineWidth = 3.0
            layer.strokeColor = UIColor.redColor().CGColor
            view.layer.addSublayer(layer)
        }
    }
    
    func layerToDraw() -> Array<MidiNoteBlock> {
        var blocks: Array<MidiNoteBlock> = Array<MidiNoteBlock>()
        let noBlocks = Float(self.noOfBars) / self.beatGrid
        let blockHight = self.view.bounds.size.width / CGFloat( noOfNotesInAnOctave)
        let blockWidth = self.view.bounds.size.height / CGFloat( noBlocks)
        
        for row in 0..<noOfNotesInAnOctave{
            for col in 0..<Int(noBlocks) {
                let rect = CGRectMake(CGFloat(CGFloat(row)*blockHight), (CGFloat(col)*CGFloat(blockWidth)), blockHight ,blockWidth)
                let block = MidiNoteBlock(rect: rect)
                blocks.append(block)
                
            }
        }
        return blocks;
    }

}

