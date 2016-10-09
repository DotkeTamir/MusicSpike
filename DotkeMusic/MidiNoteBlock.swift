import Foundation
import UIKit

/// represent the ui object of a midi note in the sequencer
class MidiNoteBlock: NSObject {
    
    var rect :CGRect
    var noteColor : CGColor
    var isSelected : Bool = false
    
    let noteValue: Int
    let notePosition: Float
    
    init(rect: CGRect, noteColor: CGColor, noteValue: Int, notePosition: Float){
        self.rect = rect
        self.noteColor = noteColor
        self.notePosition = notePosition == 0 ? 0.001 : notePosition
        self.noteValue = noteValue
        
    }
}