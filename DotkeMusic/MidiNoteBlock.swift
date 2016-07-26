import Foundation
import UIKit

/// represent the ui object of a midi note in the sequencer
class MidiNoteBlock: NSObject {
    
    var rect :CGRect
    
    init(rect: CGRect){
        self.rect = rect
        
    }
}