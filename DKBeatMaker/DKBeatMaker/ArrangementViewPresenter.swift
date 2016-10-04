import Foundation
import UIKit

class ArrangementViewPresenter {
    
    var sections: NSMutableArray
    init() {
        sections = []
    }
    
    func addMidiTrack()  {
        sections.addObject(MidiTrack.init())
    }
    
    func midiTrackForSection(section: Int) -> MidiTrack? {
        return section < sections.count ? (sections[section] as! MidiTrack) : nil
    }
    
    func addButtonTapped() {
        self.addMidiTrack()
    }
    
    func numberOfItemForSection(section: Int) -> Int {
        return 30
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
