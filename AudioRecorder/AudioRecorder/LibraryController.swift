//
//  LibraryController.swift
//  AudioRecorder
//
//  Created by Akito van Troyer on 3/26/21.
//

import AudioKit
import SwiftUI
import AVFoundation

class LibraryController : ObservableObject {
    var recordings = [String]()
    var players = [AudioPlayer]()
    var engine = AudioEngine()
    var mixer = Mixer()
    
    init(){
        self.getRecordingNames()
    }
    
    func load(){
        //Load audio file one by one to AudioPlayer using for loop
        for fileName in recordings {
            let file = loadAudioFile(file: fileName)
            let player = AudioPlayer(file: file!)
            player?.isLooping = false
            players.append(player!)
            //Add all AudioPlayers to the mixer
            mixer.addInput(player!)
        }
    }
    
    func start(){
        engine.output = mixer
        do {
            try engine.start()
        } catch {
            print(error)
        }
    }
    
    func stop(){
        engine.stop()
    }
    
    func getRecordingNames(){
        let fileManager = FileManager.default
        //Get the document directory
        let fileURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            //Get all the file names in the document directory
            recordings = try fileManager.contentsOfDirectory(atPath: fileURL.path)
        } catch {
            print("Failed to load contents of directory")
            print(error)
        }
        
        //Sort to make sure it respects the time order of recording
        recordings.sort()
    }
    
    func loadAudioFile(file: String) -> AVAudioFile? {
        var audioFile:AVAudioFile?
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        url = url.appendingPathComponent(file)
        do {
            audioFile = try AVAudioFile(forReading: url)
        } catch {
            Log("Could not load: $file")
        }
        
        return audioFile
    }
    
    func play(index: Int){
        //Stop all sounds
        for player in players {
            if player.isPlaying {
                player.stop()
            }
        }
        
        //Play the sound file at a given index
        players[index].play()
    }
}
