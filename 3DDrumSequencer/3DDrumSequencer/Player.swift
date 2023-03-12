//
//  Player.swift
//  3DDrumSequencer
//
//  Created by Akito van Troyer on 4/17/21.
//

import AudioKit
import SoundpipeAudioKit
import AVFoundation

class Player {
    var engine = AudioEngine()
    var players = [AppleSampler]()
    var mixer:Mixer!
    var panner:Panner!
    
    init(){
        var files = Bundle.main.paths(forResourcesOfType: "wav", inDirectory: "")
        files.sort()
        
        do {
            for file in files {
                let audioFile = try AVAudioFile(forReading: URL(string: file)!)
                let player = AppleSampler()
                try player.loadAudioFile(audioFile)
                players.append(player)
            }
        }
        catch {
            print("Cannot read audio file.")
        }
        
        mixer = Mixer(players)
        panner = Panner(mixer)
    }
    
    func start(){
        Settings.enableLogging = false
        
        engine.output = panner
        do {
            try engine.start()
        }
        catch {
            print("Cannot start AudioKit: ", error)
        }
    }
    
    func stop(){
        engine.stop()
    }
    
    func playSound(index: Int){
        try? players[index].play()
    }
    
    func getNumPlayers() -> Int {
        return players.count
    }
    
    func setPan(position: AUValue) {
        panner.pan = position * 2.0 - 1.0
    }
}

