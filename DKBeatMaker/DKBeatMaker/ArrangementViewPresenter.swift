import Foundation
import UIKit

class ArrangementViewPresenter {
    
    var sections: NSMutableArray
    var delegate: ArrangementViewPresenterDelegate?
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
    
    //    func cellForItemAtIndexPath (indexPath: NSIndexPath) -> UICollectionViewCell {
    //        if(indexPath.row == 0){
    //
    //        } else {
    //            collectionView.dequeueReusableCellWithReuseIdentifier(midiClipReuseIdentifier, forIndexPath: indexPath) as! MidiClipCollectionViewCell
    //
    //
    //        }
    //    }
}
