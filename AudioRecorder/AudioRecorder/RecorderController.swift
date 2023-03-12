//
//  RecorderController.swift
//  AudioRecorder
//
//  Created by Akito van Troyer on 3/26/21.
//

import SwiftUI
import AudioKitUI
import AVFoundation

class RecorderController : ObservableObject {
    @Published var audioSource = SourceType.microphone
    @Published var isRecording = false
    var recorder = AudioRecorder()
    
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
    }
 
    func record(){
        isRecording.toggle()
        if isRecording {
            recorder.startRecording(source: audioSource)
        }
        else{
            recorder.stopRecording()
        }
    }
    
    func start(){
        recorder.start()
    }
    
    func stop(){
        recorder.stop()
    }
}
