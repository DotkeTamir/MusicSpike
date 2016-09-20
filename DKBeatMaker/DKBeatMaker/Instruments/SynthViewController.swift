import Foundation
import UIKit

class SynthViewController : UIViewController {
    
    @IBOutlet weak var attackSlider: UISlider!
    @IBOutlet weak var decaySlider: UISlider!
    @IBOutlet weak var sastainSlider: UISlider!
    @IBOutlet weak var releaseSlider: UISlider!
    var conductor: Conductor!
    
    override func viewDidLoad() {
        self.attackSlider.value = Float(self.conductor.fmOscillator.attackDuration / 10)
        self.decaySlider.value = Float(self.conductor.fmOscillator.decayDuration / 10)
        self.sastainSlider.value = Float(self.conductor.fmOscillator.sustainLevel / 10)
        self.releaseSlider.value = Float(self.conductor.fmOscillator.releaseDuration / 10)
        self.octaveValueLabel.text = String(self.conductor.octave/12)
        
    }
    
    func configureWithConductor(conductor: Conductor) {
        self.conductor = conductor
    }
    
    @IBAction func attackSliderChanged(sender: AnyObject) {
        let slider = sender as! UISlider
        self.conductor.fmOscillator.attackDuration = Double(slider.value) * 10
    }
    
    @IBAction func sastainSLiderChange(sender: AnyObject) {
        let slider = sender as! UISlider
        self.conductor.fmOscillator.sustainLevel = Double(slider.value) * 10
    }
    
    @IBAction func releaseSliderChanged(sender: AnyObject) {
        let slider = sender as! UISlider
        self.conductor.fmOscillator.releaseDuration = Double(slider.value) * 10
    }
    
    @IBAction func decaySliderChanged(sender: AnyObject) {
        let slider = sender as! UISlider
        self.conductor.fmOscillator.decayDuration = Double(slider.value) * 10
    }
    
    @IBAction func upOctaveTapped(sender: AnyObject) {
        self.conductor.octave = self.conductor.octave + 12
        self.octaveValueLabel.text = String(self.conductor.octave/12)
        self.conductor.generateNewMelodicSequence(self.conductor.currentNotes)
    }
    
    @IBAction func downOctaveTapped(sender: AnyObject) {
        self.conductor.octave = self.conductor.octave - 12
        self.octaveValueLabel.text = String(self.conductor.octave/12)
        self.conductor.generateNewMelodicSequence(self.conductor.currentNotes)
    }
    
    @IBOutlet weak var octaveValueLabel: UILabel!
}



