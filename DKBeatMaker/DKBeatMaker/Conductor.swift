import AudioKit

class Conductor {
    let midi: AKMIDI = AKMIDI()
    
    var octave: Int = 38
    var fmOscillator: AKFMOscillatorBank = AKFMOscillatorBank()
    var vco1: AKMorphingOscillatorBank
    var vco1Mixer: AKMixer
    var vco1Sound: AKMIDINode?
    
    var melodicSound: AKMIDINode?
    var verb: AKReverb2?
    
    var bassDrum: AKSynthKick = AKSynthKick()
    var snareDrum: AKSynthSnare = AKSynthSnare()
    var snareGhost: AKSynthSnare = AKSynthSnare(duration: 0.06, resonance: 0.3)
    var snareMixer: AKMixer = AKMixer()
    var snareVerb: AKReverb?
    
    var sequence: AKSequencer
    var mixer: AKMixer = AKMixer()
    var pumper: AKCompressor?
    
    var currentNotes: Array<SeqMidiNote>!
    
    let scale1: [Int] = [0, 2, 4, 7, 9]
    let scale2: [Int] = [0, 3, 5, 7, 10]
    let sequenceLength = AKDuration(beats: 1.0 ,tempo: 60)
    
    init() {
        let triangle: AKTable = AKTable(.Triangle)
        let square: AKTable   = AKTable(.Square)
        let sawtooth: AKTable = AKTable(.Sawtooth)
        var squareWithHighPWM: AKTable = AKTable()
        let size: Int = squareWithHighPWM.values.count
        for i: Int in 0..<size {
            if Float(i) < Float(size) / 8.0 {
                squareWithHighPWM.values[i] = -1.0
            } else {
                squareWithHighPWM.values[i] = 1.0
            }
        }
        vco1 = AKMorphingOscillatorBank(waveformArray: [triangle, square, squareWithHighPWM, sawtooth])
        vco1Mixer = AKMixer(vco1)
        
        vco1.releaseDuration = 0.01
        vco1.attackDuration = 0
        vco1.decayDuration = 1.01
        vco1.sustainLevel = 1.1
        
        sequence = AKSequencer()
        fmOscillator.modulatingMultiplier = 3
        fmOscillator.modulationIndex = 0.3
        fmOscillator.releaseDuration = 0.01
        fmOscillator.attackDuration = 0
        fmOscillator.decayDuration = 1.01
        fmOscillator.sustainLevel = 1.1
        
        melodicSound = AKMIDINode(node: fmOscillator)
        melodicSound?.enableMIDI(midi.client, name: "melodicSound midi in")
        
        vco1Sound = AKMIDINode(node: vco1)
        vco1Sound?.enableMIDI(midi.client, name: "VOC1 midi in")
        
        verb = AKReverb2(melodicSound!)
        verb?.dryWetMix = 0.0
        verb?.decayTimeAt0Hz = 7
        verb?.decayTimeAtNyquist = 11
        verb?.randomizeReflections = 600
        verb?.gain = 0
        
        bassDrum.enableMIDI(midi.client, name: "bassDrum midi in")
        snareDrum.enableMIDI(midi.client, name: "snareDrum midi in")
        snareGhost.enableMIDI(midi.client, name: "snareGhost midi in")
        
        snareMixer.connect(snareDrum)
        snareMixer.connect(snareGhost)
        snareVerb = AKReverb(snareMixer)
        
        pumper = AKCompressor(mixer)
        
        pumper?.headRoom = 0.10
        pumper?.threshold = -15
        pumper?.masterGain = 10
        pumper?.attackTime = 0.01
        pumper?.releaseTime = 0.3
        
        mixer.connect(verb!)
        mixer.connect(bassDrum)
        mixer.connect(snareDrum)
        mixer.connect(snareGhost)
        mixer.connect(snareVerb!)
        mixer.connect(vco1Mixer)
        
        if (AudioKit.output == nil) {
            AudioKit.output = pumper
        }
        AudioKit.start()
        
        sequence.newTrack()
        sequence.setLength(sequenceLength)
        sequence.tracks[0].setMIDIOutput((melodicSound?.midiIn)!)
        
        sequence.newTrack()
        sequence.tracks[1].setMIDIOutput((vco1Sound?.midiIn)!                   )
        
        
        sequence.newTrack()
        sequence.tracks[2].setMIDIOutput(snareDrum.midiIn)
        
        sequence.enableLooping()
        sequence.setTempo(30)
    }
    
    func generateNewMelodicSequence(notes: Array<SeqMidiNote>) {
        self.currentNotes = notes
        sequence.tracks[0].clear()
        sequence.tracks[1].clear()
        sequence.setLength(sequenceLength)
        for i: Int in 0 ..< notes.count {
            sequence.tracks[1].add(noteNumber: self.octave + notes[i].noteValue,
                                   velocity: 100,
                                   position: AKDuration(beats: Double(notes[i].notePosition)),
                                   duration: AKDuration(beats: 1))
        }
        sequence.setLength(sequenceLength)
    }
    
    func generateDrumSequence(notes: Array<SeqMidiNote>) {
        sequence.tracks[1].clear()
        for i in 0 ..< notes.count {
            sequence.tracks[1].add(noteNumber: 60,
                                   velocity: 60,
                                   position: AKDuration(beats: Double(notes[i].notePosition)),
                                   duration: AKDuration(beats: 0.5))
        }
        sequence.setLength(sequenceLength)
    }
    
    func generateSequence() {
        generateNewMelodicSequence([])
    }
    
    func clear() {
        sequence.tracks[0].clear()
    }
    
    func startPlaying() {
        sequence.play()
    }
    func stopPlaying() {
        sequence.stop()
    }
}
