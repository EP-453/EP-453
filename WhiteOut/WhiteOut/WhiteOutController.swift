//
//  WhiteOutController.swift
//  WhiteOut
//
//  Created by Akito van Troyer on 4/2/21.
//

import SwiftUI
import AVFoundation

class WhiteOutController : ObservableObject {
    var synth = WhiteOutSynth()
    var timer:Timer!
    let fftSize = 512
    
    @Published var amplitudes:[Float] = Array(repeating: 0.5, count: 50)
    @Published var location = CGPoint() {
        didSet {
            synth.setFrequency(freq: Double(location.x))
            synth.setResonance(res: Double(location.y))
        }
    }
    @Published var warn = false
    
    init(){
        do {
            //Tell AVAudioSession to enable playback/recording. Also tell it to play the sound from the speaker
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord,
                                                            options: [.defaultToSpeaker, .mixWithOthers])
            //Tell AVAudioSession to activate the setting above
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let err {
            print(err)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update(){
        let fftData = synth.getFFTData()
        
        for i in stride(from: 0, to: fftSize - 1, by: 2) {
            // get the real and imaginary parts of the complex number
            let real = fftData[i]
            let imaginary = fftData[i + 1]
            
            let normalizedBinMagnitude = (2.0 * sqrt(real * real + imaginary * imaginary)) / Float(self.fftSize)
            let amplitude = (20.0 * log10(normalizedBinMagnitude))
            
            // scale the resulting data
            var scaledAmplitude = (amplitude + 250) / 229.80
            
            // restrict the range to 0.0 - 1.0
            if (scaledAmplitude < 0) {
                scaledAmplitude = 0
            }
            if (scaledAmplitude > 1.0) {
                scaledAmplitude = 1.0
            }
            
            if(i/2 < self.amplitudes.count){
                self.amplitudes[i/2] = self.scale(num: scaledAmplitude, minNum: 0.3, maxNum: 0.9, scaleMin: 0, scaleMax: 1)
            }
        }
    }
    
    func scale(num: Float, minNum: Float, maxNum: Float, scaleMin: Float, scaleMax: Float) -> Float {
        if (num <= minNum) {return scaleMin}
        if (num >= maxNum) {return scaleMax}
        return (num-minNum)/(maxNum-minNum) * (scaleMax-scaleMin) + scaleMin
    }
    
    func start(){
        checkForHeadphones()
        synth.start()
    }
    
    func stop(){
        synth.stop()
    }
    
    // Warn user about feedback if headphones are not connected
    func checkForHeadphones() {
        warn = headphonesPlugged()
    }
    
    // Return a BOOL signifying whether or not headphones are connected to the current device
    func headphonesPlugged() -> Bool {
        let availableOutputs = AVAudioSession.sharedInstance().currentRoute.outputs
        for out in availableOutputs {
            if out.portType == AVAudioSession.Port.headphones {
                return false
            }
        }
        return true
    }
}
