//
//  ProcessorController.swift
//  Navigation
//
//  Created by Akito van Troyer on 1/29/21.
//

import AudioKit
import AudioKitEX
import AVFoundation

class ProcessorController: ObservableObject {
    let engine = AudioEngine()
    let decimator:Decimator?
    let lpf:LowPassFilter?
    let reverb:Reverb?
    let fader:Fader?
    var rampTime:AUValue = 0.2
    
    var gainRange: ClosedRange<AUValue> = 0...1
    @Published var gain: AUValue = 0.2 {
        didSet {
            fader?.$leftGain.ramp(to: gain, duration: rampTime)
            fader?.$rightGain.ramp(to: gain, duration: rampTime)
        }
    }

    var decimationRange: ClosedRange<AUValue> = 0...50
    @Published var decimation: AUValue = 0 {
        didSet {
            decimator?.decimation = decimation
        }
    }

    var dryWetRange: ClosedRange<AUValue> = 0...1
    @Published var dryWet: AUValue = 0.5 {
        didSet {
            reverb?.dryWetMix = dryWet
        }
    }
    
    init() {
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        
        // WARNING: Force Speaker output, meaning audio feedback! Cover your Ear!!
        // In this case, `Settings.defaultToSpeaker = true` property from AudioKit
        // may be more appropriate.
        // This ensures audio comes out from the receiver when headphones are not connected (no feebdack)
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
        } catch {
            print("Couldn't override output audio port")
        }
        
        // Comment out the do statement above when using this option
        //Settings.defaultToSpeaker = true
        
        //Get microphone input
        guard let mic = engine.input else {
            fatalError()
        }
        
        //Intialize Decimator
        decimator = Decimator(mic)
        decimator?.decimation = 0 // Normalized Value 0 - 100
        decimator?.rounding = 50 // Normalized Value 0 - 100
        decimator?.finalMix = 100 // Normalized Value 0 - 100

        //Initialize LPF
        lpf = LowPassFilter(decimator!)
        lpf?.cutoffFrequency = AUValue(Settings.sampleRate / 2.0)
        lpf?.resonance = 10
        
        //Intialize Reverb
        reverb = Reverb(lpf!)
        reverb?.dryWetMix = 0.5

        //Control amplitude with Fader
        fader = Fader(reverb!)
        fader?.gain = 0.2
        
        //Assign Fader as the final destination to audio output
        engine.output = fader
    }
    
    func start(){
        do {
            try engine.start()
        } catch let error {
            Log(error)
        }
    }
    
    func stop(){
        engine.stop()
    }
}
