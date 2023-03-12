//
//  PlaybackController.swift
//  SamplePlayback
//
//  Created by Akito van Troyer on 1/21/21.
//

import Foundation
import SwiftUI
import AudioKit
import AVFoundation

class PlaybackController: ObservableObject {
    let engine = AudioEngine()
    var mixer:Mixer?
    var guitar:AudioPlayer?
    var trumpet:AudioPlayer?
    var loop:AudioPlayer?
    
    func setupPlayback(){
        let guitarFile = loadAudioFile(file: "Sounds/guitar.wav")
        guitar = AudioPlayer(file: guitarFile!)
        guitar?.isLooping = false
        let trumpetFile = loadAudioFile(file: "Sounds/trumpet.wav")
        trumpet = AudioPlayer(file: trumpetFile!)
        trumpet?.isLooping = false
        let loopFile = loadAudioFile(file: "Sounds/loop.wav")
        loop = AudioPlayer(file: loopFile!)
        loop?.isLooping = true
        
        mixer = Mixer([guitar!, trumpet!, loop!])
        engine.output = mixer
        
        do {
            try engine.start()
        } catch {
            Log("AudioKit did not start! \(error)")
        }
    }
    
    func loadAudioFile(file: String) -> AVAudioFile? {
        var audioFile:AVAudioFile?
        guard let url = Bundle.main.resourceURL?.appendingPathComponent(file) else { return nil }
        do {
            audioFile = try AVAudioFile(forReading: url)
        } catch {
            Log("Could not load: $file")
        }
        
        return audioFile
    }
    
    func stop(){
        engine.stop()
    }
    
    func playGuitar(){
        if ((guitar?.isStarted) != nil) {
            guitar?.stop()
        }
        guitar?.play()
    }
    
    func playTrumpet(){
        if((trumpet?.isStarted) != nil){
            trumpet?.stop()
        }
        trumpet?.play()
    }
    
    func playLoop(){
        loop?.play()
    }
    
    func stopLoop(){
        loop?.stop()
    }
}

struct PlaybackControlView: View {
    @ObservedObject var controller = PlaybackController()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Image("background")
                    .resizable()
                    .aspectRatio(geometry.size, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer()
                    Button(action: controller.playGuitar) {
                        Image("guitar")
                    }
                    .padding()
                    Button(action: controller.playTrumpet) {
                        Image("trumpet")
                    }
                    .padding()
                    Spacer()
                    HStack {
                        Button(action: controller.playLoop) {
                            Text("Play")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .font(.system(size: 40))
                        }
                        .padding()
                        Spacer()
                        Button(action:controller.stopLoop) {
                            Text("Stop")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .font(.system(size: 40))
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            controller.setupPlayback()
        }
        .onDisappear {
            controller.stop()
        }
    }
}

struct PlaybackControlView_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackControlView()
    }
}
