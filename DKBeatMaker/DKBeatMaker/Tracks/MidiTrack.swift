// representation of the midi track, holds the number of the midi clips 
// and in the future will have the midi clips store within it.
import Foundation

class MidiTrack {
    var midiClips: NSMutableArray
    
    init(){
        midiClips = []
    }
    
    func addMidiClip(midiClip: MidiClipCollectionViewCell) {
        midiClips.addObject(midiClips)
    }
    
    func numberofClips() -> Int {
       return midiClips.count
    }
}
