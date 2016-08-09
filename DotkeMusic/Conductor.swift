import AudioKit

class Conductor {
    let midi = AKMIDI()
    
    var fmOscillator = AKFMOscillatorBank()
    var melodicSound: AKMIDINode?
    var verb: AKReverb2?
    
    var bassDrum = AKSynthKick()
    var snareDrum = AKSynthSnare()
    var snareGhost = AKSynthSnare(duration: 0.06, resonance: 0.3)
    var snareMixer = AKMixer()
    var snareVerb: AKReverb?
    
    var sequence = AKSequencer()
    var mixer = AKMixer()
    var pumper: AKCompressor?
    
    var currentTempo = 110.0
    
    let scale1: [Int] = [0, 2, 4, 7, 9]
    let scale2: [Int] = [0, 3, 5, 7, 10]
    let sequenceLength = AKDuration(beats: 1.0 ,tempo: 60)
    
    init() {
        fmOscillator.modulatingMultiplier = 3
        fmOscillator.modulationIndex = 0.3
        fmOscillator.releaseDuration = 0.01
        fmOscillator.attackDuration = 0
        fmOscillator.decayDuration = 0.01
        fmOscillator.sustainLevel = 0.1
        
        melodicSound = AKMIDINode(node: fmOscillator)
        melodicSound?.enableMIDI(midi.client, name: "melodicSound midi in")
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
        
        AudioKit.output = pumper
        AudioKit.start()
        
        sequence.newTrack()
        sequence.setLength(sequenceLength)
        sequence.tracks[0].setMIDIOutput((melodicSound?.midiIn)!)
        
        sequence.newTrack()
        sequence.tracks[1].setMIDIOutput(bassDrum.midiIn)
        
        
        sequence.newTrack()
        sequence.tracks[2].setMIDIOutput(snareDrum.midiIn)
        
        sequence.enableLooping()
        sequence.setTempo(30)
//        sequence.setTempo(120)
        sequence.play()
        
    }
    func generateNewMelodicSequence(notes: Array<MidiNoteBlock>) {
      sequence.tracks[0].clear()
        sequence.setLength(sequenceLength)
//        let numberOfSteps = Int(Float(sequenceLength.beats)/stepSize)
//        print("steps in sequence: \(numberOfSteps)")
        for i in 0 ..< notes.count {
            //            if (arc4random_uniform(17) > 12) {
//            let step = Double(i) * notes[i].notePosition
            ////                 print("step is \(step)")
            //                let scale = (minor ? scale2 : scale1)
            //                let scaleOffset = arc4random_uniform(UInt32(scale.count)-1)
            //                var octaveOffset = 0
            //                for _ in 0 ..< 2 {
            //                    octaveOffset += Int(12 * (((Float(arc4random_uniform(2)))*2.0)+(-1.0)))
            //                    octaveOffset = Int((Float(arc4random_uniform(2))) * (Float(arc4random_uniform(2))) * Float(octaveOffset))
            //                }
            print("notes[i].notePosition is \((notes[i].notePosition))")
            print("note value is \((50+notes[i].noteValue))")
            //                let noteToAdd = 60 + scale[Int(scaleOffset)] + octaveOffset
            sequence.tracks[0].add(noteNumber: 60+notes[i].noteValue,
                                                          velocity: 100,
                                                          position: AKDuration(beats: Double(notes[i].notePosition)),
                                                          duration: AKDuration(beats: 1))
        }
        sequence.setLength(sequenceLength)
    }
    
    func generateDrumSequence(notes: Array<MidiNoteBlock>) {
        
        
//        let numberOfSteps = Int(Float(sequenceLength.beats)/stepSize)
        for i in 0 ..< notes.count {
            sequence.tracks[notes[i].noteValue].clear()
//            let step = Double(i) * stepSize
            print("notes[i].notePosition is \((notes[i].notePosition))")
            print("note value is \((notes[i].noteValue))")

            sequence.tracks[2].add(noteNumber: 60,
                                                            velocity: 60,
                                                            position: AKDuration(beats: Double(notes[i].notePosition)),
                                                            duration: AKDuration(beats: 0.5))
        }
//        print("position:%@",sequence.currentPosition)
//        print("debug :%@",sequence.debug())
        
    }
    
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0 ? true : false
    }
    
    func generateSequence() {
        generateNewMelodicSequence([])
    }
    
    func clear() {
        sequence.tracks[0].clear()
    }
    
    func increaseTempo() {
        currentTempo += 1.0
        sequence.setTempo(currentTempo)
    }
    
    func decreaseTempo() {
        currentTempo -= 1.0
        sequence.setTempo(currentTempo)
    }
}
