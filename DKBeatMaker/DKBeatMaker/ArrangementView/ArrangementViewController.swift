import UIKit

let reuseIdentifier: String = "MidiClipCell"

class ArrangementViewController: UICollectionViewController {
    var arrPresenter: ArrangementViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrPresenter = ArrangementViewPresenter.init()
        
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.arrPresenter?.sections.count)!
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let items: Int = (arrPresenter?.midiTrackForSection(section)?.midiClips.count)!
        return items
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MidiClipCollectionViewCell
        
            cell.label.text = "Sec \((indexPath as NSIndexPath).section)/Item \((indexPath as NSIndexPath).item)"
            return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SeqSegue", sender: self)

    }
    
}
