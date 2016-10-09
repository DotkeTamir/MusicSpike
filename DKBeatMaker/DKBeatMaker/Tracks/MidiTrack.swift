// representation of the midi track, holds the number of the midi clips
// and in the future will have the midi clips store within it.
import Foundation

class MidiTrack {
    // Holds the audio controller, which always be the first element./
    // This controller represent the following functionality: Mute, Solo, Volume, Add Clip
    var midiClips: NSMutableArray
    
    init(){
        midiClips = []
    }
    
    func addAudioController(audioController: AudioControllerModel) {
        midiClips.addObject(audioController)
    }
    
    func addMidiClip(midiClip: MidiClipModel) {
        midiClips.addObject(midiClip)
    }
    
    func numberofClips() -> Int {
        return midiClips.count
    }
}
