import Foundation
import UIKit

/// represent the ui object of a midi note in the sequencer
class MidiNoteBlock: NSObject {
    
    var rect :CGRect
    var noteColor : CGColor
    
    init(rect: CGRect, noteColor: CGColor){
        self.rect = rect
        self.noteColor = noteColor
        
    }
}