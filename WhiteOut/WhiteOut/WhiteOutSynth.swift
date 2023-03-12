//
//  WhiteOutSynth.swift
//  WhiteOut
//
//  Created by Akito van Troyer on 4/2/21.
//

import AudioKit
import AudioKitEX
import SoundpipeAudioKit
import Foundation

class WhiteOutSynth {
    var engine = AudioEngine()
    var noise:WhiteNoise!
    var filter:LowPassFilter!
    var reverb:Reverb!
    var fft:FFTTap!
    var mic:AudioEngine.InputNode!
    var amp:AmplitudeTap!
    var fftData = [Float]()
    var mixer:Mixer!
    
    init(){
        // Track the amp of microhpne input
        guard let input = engine.input else {
            fatalError()
        }
        
        //Track microphone signal
        mic = input
        amp = AmplitudeTap(mic, callbackQueue: .main) { amp in
            self.noise.amplitude = amp * 15
        }
    
        // Keep the audio silent at the beginning
        noise = WhiteNoise(amplitude: 0)
        filter = LowPassFilter(noise, cutoffFrequency: AUValue(Settings.sampleRate * 0.125), resonance: 0)
        reverb = Reverb(filter)
        
        //Add Fader to the mic input, a trick to get FFTTap to get audio signal from the mic input
        let fader = Fader(mic)
        mixer = Mixer([Fader(fader, gain: 0), reverb])
        
        // Track the spectrum of the filtered noise
        fft = FFTTap(fader, callbackQueue: .main){ fftData in
            self.fftData = fftData
        }

        // Make AudioKit more responsive to microphone input
        Settings.bufferLength = .shortest
    }
    
    func start(){
        //Start microphon input and noise source
        mic.start()
        noise.start()
        
        //Start the audio engine
        engine.output = mixer
        do {
            try engine.start()
        } catch {
            print(error)
        }

        //Taps seemed to like to start after the engine is started
        fft.start()
        amp.start()
        
        // Start a timer to track microphone amplitude
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAmp), userInfo: nil, repeats: true)
    }
    
    func stop(){
        mic.stop()
        fft.start()
        amp.stop()
        engine.stop()
    }
    
    @objc func updateAmp(){
        noise.amplitude = amp.amplitude * 15
    }
    
    //Assumes freq value in between 0 ~ 1
    func setFrequency(freq: Double) {
        filter?.cutoffFrequency = AUValue(freq * Settings.sampleRate * 0.125)
    }
    
    //Assumes res value in between 0 ~ 1
    func setResonance(res: Double) {
        filter?.resonance = AUValue(res * 20)
    }
    
    func getFFTData() -> [Float] {
        return fft.fftData
    }
}
