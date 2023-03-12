//
//  MultiTouchSynth.swift
//  MultiTouchSynth
//
//  Created by Akito van Troyer on 3/15/21.
//

import AudioKit
import SoundpipeAudioKit
import AVFoundation

class MultiTouchSynth {
    let engine = AudioEngine()
    let mixer = Mixer()
    var ids = [Int:Int]()
    var nodes = [[Node]]()
    var count = 0
    
    init(){
        for _ in 0..<MultiTouchController.numFingers {
            add()
        }
    }

    func add(){
        let osc = MorphingOscillator(waveformArray: [Table(.sine), Table(.triangle), Table(.sawtooth), Table(.square)])
        let filter = StringResonator(osc)
        let env = AmplitudeEnvelope(filter)
        env.attackDuration = 0.1
        env.decayDuration = 0.1
        env.releaseDuration = 0.1
        let reverb = ZitaReverb(env)
        mixer.addInput(reverb)
        
        //Keep track of all our Nodes so that we can modify them later
        nodes.append([osc, filter, env, reverb])
    }
    
    func update(id: Int, point: CGPoint){
        //Check if the hash id from a touch point exsits in the ids dictionary
        if ids[id] == nil {
            //if the id does not exist, make a link between the hash id and count id in this synth class
            ids[id] = count
            //Advance the count
            count += 1
            //Start the synthesizer for this particular touch
            let synths = nodes[ids[id]!]
            let env = synths[2] as! AmplitudeEnvelope
            env.stop() //XXX for weirdest reason stop starts the envelope
        }
        //Convert point.y (0~1) to frequency range (60 ~ 3000)
        let freq = scale(num: point.y, minNum: 0, maxNum: 1, scaleMin: 3000, scaleMax: 60)
        let synths = nodes[ids[id]!]
        let osc = synths[0] as! MorphingOscillator
        osc.frequency = AUValue(freq)
        //Morph between four wavetables (0 ~ 3)
        osc.index = AUValue(point.x) * 3
        let filter = synths[1] as! StringResonator
        filter.fundamentalFrequency = AUValue(freq)
    }
    
    func stopSynth(id: Int){
        let synths = nodes[ids[id]!]
        (synths[2] as! AmplitudeEnvelope).start() //XXX for weirdest reason start stops the envelope
        ids.removeValue(forKey: id)
        count -= 1
    }
    
    func start(){
        engine.output = mixer
        
        do {
            try engine.start()
        } catch let error {
            Log(error)
        }
        
        //Start all Oscillator
        for node in nodes {
            (node[0] as! MorphingOscillator).start()
        }
    }
    
    func stop() {
        //Stopt all Oscillator
        for node in nodes {
            (node[0] as! MorphingOscillator).stop()
        }
        engine.stop()
    }
    
    func scale(num: CGFloat, minNum: CGFloat, maxNum: CGFloat,
    scaleMin: CGFloat, scaleMax: CGFloat) -> CGFloat {
        if (num <= minNum) {return scaleMin}
        if (num >= maxNum) {return scaleMax}
        return (num-minNum)/(maxNum-minNum) * (scaleMax-scaleMin) + scaleMin
    }
}
