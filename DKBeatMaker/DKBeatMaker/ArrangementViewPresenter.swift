import Foundation

class ArrangementViewPresenter {
    
    // @[sectionNumber : NumberOfItemsInSection]
    var sections: NSMutableArray
    init() {
        sections = []
    }
    
    func addMidiTrack()  {
        sections.add(MidiTrack.init())
    }
    
    func midiTrackForSection(_ section: Int) -> MidiTrack? {
        return section < sections.count ? (sections[section] as! MidiTrack) : nil
    }
    
}
