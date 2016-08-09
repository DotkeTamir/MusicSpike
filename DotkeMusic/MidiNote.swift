import Foundation
import UIKit

class MidiNote: NSObject {
    
    /// UI representation of the midi note
    var layer: CALayer
    /// the note value, as should be represented by the synth
    var noteValue: NSInteger

    init(layer: CALayer, noteValue: NSInteger) {
        self.layer = layer
        self.noteValue = noteValue
        
    }
}