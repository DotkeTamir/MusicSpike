import Foundation
import UIKit

class SynthViewController : UIViewController {
    
    @IBOutlet weak var attackSlider: UISlider!
    @IBOutlet weak var decaySlider: UISlider!
    @IBOutlet weak var sastainSlider: UISlider!
    @IBOutlet weak var releaseSlider: UISlider!
    var conductor: Conductor!
    
    override func viewDidLoad() {
        self.attackSlider.value = Float(self.conductor.fmOscillator.attackDuration)
        self.decaySlider.value = Float(self.conductor.fmOscillator.decayDuration)
        self.sastainSlider.value = Float(self.conductor.fmOscillator.sustainLevel)
        self.releaseSlider.value = Float(self.conductor.fmOscillator.releaseDuration)
        self.octaveValueLabel.text = String(self.conductor.octave/12)
        
    }
    
    func configureWithConductor(conductor: Conductor) {
        self.conductor = conductor
    }
    
    @IBAction func attackSliderChanged(sender: AnyObject) {
        let slider = sender as! UISlider
        self.conductor.fmOscillator.attackDuration = Double(slider.value)
        self.conductor.vco1.attackDuration = Double(slider.value)
    }
    
    @IBAction func sastainSLiderChange(sender: AnyObject) {
        let slider = sender as! UISlider
        self.conductor.fmOscillator.sustainLevel = Double(slider.value)
        self.conductor.vco1.sustainLevel = Double(slider.value)
    }
    
    @IBAction func releaseSliderChanged(sender: AnyObject) {
        let slider = sender as! UISlider
        self.conductor.fmOscillator.releaseDuration = Double(slider.value)
        self.conductor.vco1.releaseDuration = Double(slider.value)
    }
    
    @IBAction func decaySliderChanged(sender: AnyObject) {
        let slider = sender as! UISlider
        self.conductor.fmOscillator.decayDuration = Double(slider.value)
        self.conductor.vco1.decayDuration = Double(slider.value)
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
    
    @IBAction func waveformTapped(sender: AnyObject) {
        var index = self.conductor.vco1.index
        
        if index > 3 {
            index = 0
        }else {
            index = index + 1
        }
        self.conductor.vco1.index = index
        self.waveformButton.titleLabel?.text = String(index)
    }
    
    @IBOutlet weak var waveformButton: UIButton!
    
}



