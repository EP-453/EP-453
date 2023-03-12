//
//  DrumController.swift
//  TabPlayer
//
//  Created by Akito van Troyer on 3/9/21.
//

import Foundation
import AudioKit

class DrumController: ObservableObject {
    let engine = AudioEngine()
    let mixer = Mixer()
    let drumPad:DrumPad?
    let drumSynth:DrumSynth?
    
    init(){
        drumPad = DrumPad()
        drumSynth = DrumSynth()
    }
    
    func start(){
        
        for player in drumPad!.players {
            mixer.addInput(player)
        }
        
        mixer.addInput(drumSynth!.output!)
        
        engine.output = mixer
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
