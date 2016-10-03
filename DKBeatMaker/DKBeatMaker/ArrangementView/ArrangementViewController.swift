import UIKit

let reuseIdentifier: String = "MidiClipCell"

class ArrangementViewController: UICollectionViewController {
    var arrPresenter: ArrangementViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrPresenter = ArrangementViewPresenter.init()
        
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (self.arrPresenter?.sections.count)!
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let items: Int = (arrPresenter?.midiTrackForSection(section)?.midiClips.count)!
        return items
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MidiClipCollectionViewCell
        
            cell.label.text = "Sec \(indexPath.section)/Item \(indexPath.item)"
            return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("SeqSegue", sender: self)

    }
    
}
