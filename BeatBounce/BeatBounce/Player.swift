//
//  Player.swift
//  BeatBounce
//
//  Created by Akito van Troyer on 4/5/21.
//

import AudioKit
import AVFoundation

class Player {
    var engine = AudioEngine()
    var players = [AppleSampler]()
    var mixer:Mixer!
    var links = [String:AppleSampler]()
    var count = 0
    
    init(){
        var files = Bundle.main.paths(forResourcesOfType: "wav", inDirectory: "Samples")
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
    }
    
    func start(){
        Settings.enableLogging = false
        
        engine.output = mixer
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
    
    func linkSound(ball: String){
        if !links.keys.contains(ball) {
            if count < players.count {
                links[ball] = players[count]
                count += 1
            }
        }
    }
    
    func playSound(ball: String){
        if links.keys.contains(ball) {
            do {
                try links[ball]?.play()
            }
            catch {
                print(error)
            }
            
        }
    }
}

