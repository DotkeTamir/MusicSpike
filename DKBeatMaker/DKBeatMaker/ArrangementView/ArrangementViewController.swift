import UIKit

let midiClipReuseIdentifier: String = "MidiClipCell"
let audioControllerReuseIdentifier: String = "audioControllerCell"

class ArrangementViewController: UICollectionViewController, AddClipDelegate, ArrangementViewSurface{
    var arrangementViewPresenter: ArrangementViewPresenter?
    
    @IBOutlet weak var multiDirectionalLayout: MultiDirectionalCollectionViewLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrangementViewPresenter = ArrangementViewPresenter.init()
        self.arrangementViewPresenter?.delegate = self
        
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (self.arrangementViewPresenter?.sections.count)!
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.arrangementViewPresenter?.numberOfItemForSection(section))!
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(audioControllerReuseIdentifier, forIndexPath: indexPath) as! AudioControllerCell
            cell.trackNumber = indexPath.section
            cell.delegate = self
            return cell
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(midiClipReuseIdentifier, forIndexPath: indexPath) as! MidiClipCollectionViewCell
            cell.label.text = "Sec \(indexPath.section)/Item \(indexPath.item)"
            return cell
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let identifier: String = (self.arrangementViewPresenter?.seguaIdentifierForIndexPath(indexPath))!
        
        if(identifier != ""){
            self.performSegueWithIdentifier(identifier, sender: self)
        }
        
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        self.arrangementViewPresenter?.addButtonTapped()
    }
    
    func addClipForTrackNumber(trackNumber: Int) {
        self.arrangementViewPresenter?.addMidiClip(trackNumber)
    }
    
    // MARK: ArrangementViewSurface
    func reloadCollectionView() {
        self.collectionView?.reloadData()
        self.multiDirectionalLayout.dataSourceDidUpdate = true
    }
}
