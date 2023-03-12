//
//  SynthController.swift
//  Synthesizer
//
//  Created by Akito van Troyer on 1/27/21.
//

import Foundation
import SwiftUI
import AudioKit
import AudioKitUI
import Keyboard
import SoundpipeAudioKit

enum Waveform {
    case sine, sawtooth, square, triangle
}

class SynthController: ObservableObject {
    let engine = AudioEngine()
    var osc = MorphingOscillator(waveformArray: [Table(.sine), Table(.sawtooth), Table(.square), Table(.triangle)], amplitude: 0)
    
    init() {
        engine.output = osc
    }
    
    func start(){
        osc.index = 0
        osc.start()
        do {
            try engine.start()
        } catch let error {
            Log(error)
        }
    }
    
    func stop(){
        osc.stop()
        engine.stop()
    }
    
    func setWaveform(tableType: TableType) {
        switch tableType {
        case .sine:
            osc.index = 0
        case .sawtooth:
            osc.index = 1
        case .square:
            osc.index = 2
        case .triangle:
            osc.index = 3
        default:
            osc.index = 0
        }
    }
    
    func noteOn(pitch: Pitch, point: CGPoint) {
        osc.frequency = pitch.intValue.midiNoteToFrequency()
        osc.amplitude = AUValue(point.y)
    }
    
    func noteOff(pitch: Pitch) {
        osc.amplitude = 0
    }
}

struct SynthView : View {
    @ObservedObject var controller = SynthController()
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        VStack {
            Spacer()
            ButtonView(controller: controller)
            Spacer()
            Keyboard(layout: .piano(pitchRange: Pitch(intValue: 60) ... Pitch(intValue: 84)), noteOn: controller.noteOn(pitch:point:), noteOff: controller.noteOff(pitch:))
                .frame(height: screenSize.height/2)
        }
        .onAppear(){
            controller.start()
        }
        .onDisappear(){
            controller.stop()
        }
        .background(Color(red: 0.9, green: 0.9, blue: 0.9))
    }
}

// A view responsible for creating buttons for changing waveforms
// Buttons are stacked horizontally
struct ButtonView: View {
    var controller:SynthController
    @State var waveForm:Waveform = .sine
    
    var body: some View {
        HStack {
            Button(action: {
                self.waveForm = .sine
                controller.setWaveform(tableType: .sine)
            }) {
                Image(waveForm == .sine ? "SIN" : "SINOFF")
                    .resizable()
                    .frame(width: 64, height: 64)
            }
            Button(action: {
                self.waveForm = .sawtooth
                controller.setWaveform(tableType: .sawtooth)
            }) {
                Image(waveForm == .sawtooth ? "SAW" : "SAWOFF")
                    .resizable()
                    .frame(width: 64, height: 64)
            }
            Button(action: {
                self.waveForm = .square
                controller.setWaveform(tableType: .square)
            }) {
                Image(waveForm == .square ? "SQR" : "SQROFF")
                    .resizable()
                    .frame(width: 64, height: 64)
            }
            Button(action: {
                self.waveForm = .triangle
                controller.setWaveform(tableType: .triangle)
            }) {
                Image(waveForm == .triangle ? "TRI" : "TRIOFF")
                    .resizable()
                    .frame(width: 64, height: 64)
            }
        }
    }
}
