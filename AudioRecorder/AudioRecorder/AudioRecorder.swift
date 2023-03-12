//
//  AudioRecorder.swift
//  AudioRecorder
//
//  Created by Akito van Troyer on 3/26/21.
//

import AudioKit
import AudioKitEX
import SoundpipeAudioKit
import AVFoundation

// Keep track of which audio source to record with this enum
enum SourceType: String, CaseIterable {
    case microphone = "Microphone"
    case synthesizer = "Synthesizer"
}

class AudioRecorder {
    var engine = AudioEngine()
    var mic:AudioEngine.InputNode! //For mic
    var osc:Oscillator!
    var mixer:Mixer!
    //Default to mic
    var curSource:SourceType = .microphone
    
    // Control synthe with timer
    var timer:Timer!
    var curNote:MIDINoteNumber = 60
    
    // For Recording
    var recorder:NodeRecorder!
    
    init() {
        //Begin mic input aquisition
        guard let input = engine.input else {
            fatalError()
        }
        mic = input
        osc = Oscillator(waveform: Table(.sine))
        mixer = Mixer([Fader(mic, gain: 0), osc])
        
        //Delete files if needed
//        deleteRecordings()
    }
    
    func startRecording(source: SourceType){
        //Remove all temp files before recording
        NodeRecorder.removeRecordedFiles()
        do{
            switch source {
            case .microphone:
                curSource = .microphone
                recorder = try NodeRecorder(node: mic)
                break
            case .synthesizer:
                curSource = .synthesizer
                recorder = try NodeRecorder(node: osc)
                startTimer()
                break
            }

            try recorder.record()
        } catch let error {
            Log(error)
        }
    }

    func stopRecording() {
        recorder.stop()
        if curSource == .synthesizer {
            stopTimer()
        }
        saveRecording()
    }
    
    func saveRecording(){
        //Use current time as the name of file
        let format = DateFormatter()
        format.dateFormat = "yMMddHHmmss"
        let fileManager = FileManager.default
        //Get document directory
        var url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //append the file name to the directory
        url = url.appendingPathComponent("\(format.string(from: Date())).caf")
        
        do {
            //Copy the sound file from temporary directory to document directory if the file exists
            if fileManager.fileExists(atPath: (recorder.audioFile?.url.path)!){
                try fileManager.copyItem(at: (recorder.audioFile?.url)!, to: url)
            }
        } catch {
            print("Error while enumerating files \(url.path): \(error.localizedDescription)")
        }
    }
    
    func startTimer(){
        //start the time for random melody generator
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(randomFreq), userInfo: nil, repeats: true)
        osc.start()
    }
    
    @objc func randomFreq(){
        //Randomly genrate MIDI note and convert it to frequency
        let note = MIDINoteNumber(Int8.random(in: 60...72))
        osc.frequency = note.midiNoteToFrequency()
    }

    func stopTimer(){
        timer.invalidate()
        osc.stop()
    }
    
    func start(){
        engine.output = mixer
        do {
            try engine.start()
        }
        catch {
            print("Cannot start AudioKit")
        }
    }
    
    func stop(){
        engine.stop()
    }
    
    //Use this function in the init function when you want to delete all recordings
    func deleteRecordings(){
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for file in files {
                try fileManager.removeItem(at: file)
            }
        } catch {
            print(error)
        }
    }
}

