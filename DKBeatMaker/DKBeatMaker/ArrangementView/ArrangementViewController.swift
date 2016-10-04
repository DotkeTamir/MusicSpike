import UIKit

let midiClipReuseIdentifier: String = "MidiClipCell"
let audioControllerReuseIdentifier: String = "audioControllerCell"

class ArrangementViewController: UICollectionViewController {
    var arrangementViewPresenter: ArrangementViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrangementViewPresenter = ArrangementViewPresenter.init()
        
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 20//(self.arrangementViewPresenter?.sections.count)!
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.arrangementViewPresenter?.numberOfItemForSection(section))!
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        var cell: UICollectionViewCell
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(audioControllerReuseIdentifier, forIndexPath: indexPath) as! AudioControllerCell
            cell.trackNumber = indexPath.section
            return cell
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(midiClipReuseIdentifier, forIndexPath: indexPath) as! MidiClipCollectionViewCell
            cell.label.text = "Sec \(indexPath.section)/Item \(indexPath.item)"
            return cell
        }
//        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("SeqSegue", sender: self)
        
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        self.arrangementViewPresenter?.addButtonTapped()
    }
}
