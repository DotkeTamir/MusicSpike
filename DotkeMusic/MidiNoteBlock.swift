import Foundation
import UIKit

/// represent the ui object of a midi note in the sequencer
class MidiNoteBlock: NSObject {
    
    var rect :CGRect
    var noteColor : CGColor
    var isSelected : Bool = false
    
    init(rect: CGRect, noteColor: CGColor){
        self.rect = rect
        self.noteColor = noteColor
        
    }
}