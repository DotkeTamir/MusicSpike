import Foundation
import UIKit

class ArrangementViewPresenter {
    
    // Could and maybe should be moved to a model object, thinking to do that as a second stage.
    var sections: NSMutableArray
    var delegate: ArrangementViewSurface?
    
    init() {
        sections = []
    }
    
    func addMidiTrack()  {
        let track: MidiTrack = MidiTrack.init()
        track.addAudioController(AudioControllerModel())
        sections.addObject(track)
        self.delegate?.reloadCollectionView()
    }
    
    func addMidiClip(trackNumber:Int) {
        let midiClip : MidiClipModel = MidiClipModel()
        self.midiTrackForSection(trackNumber)?.addMidiClip(midiClip)
        self.delegate?.reloadCollectionView()
    }
    
    func midiTrackForSection(section: Int) -> MidiTrack? {
        return section < sections.count ? (sections[section] as! MidiTrack) : nil
    }
    
    func addButtonTapped() {
        self.addMidiTrack()
    }
    
    func numberOfItemForSection(section: Int) -> Int {
        let items: Int = (self.midiTrackForSection(section)?.midiClips.count)!
        return items
    }
    
    func seguaIdentifierForIndexPath(indexPath: NSIndexPath) -> String? {
        if(indexPath.row != 0){
                return "SeqSegue"
        }
        return nil
        
    }
}
