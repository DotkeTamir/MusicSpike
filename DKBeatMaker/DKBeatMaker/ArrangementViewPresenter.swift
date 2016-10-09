import Foundation

class ArrangementViewPresenter {
    
    // @[sectionNumber : NumberOfItemsInSection]
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
    
}
