//
//  DrumSynth.swift
//  TabPlayer
//
//  Created by Akito van Troyer on 2/25/21.
//

import SwiftUI
import AudioKit
import SporthAudioKit

class DrumSynth: ObservableObject {
    let kick = SynthKick()
    let snare = SynthSnare(duration: 0.07)
    let output:Reverb?
    var loop: CallbackLoop?
    var counter = 0
    @Published var beats = [1, 2, 4, 8, 16, 32, 64]
    @Published var kickBeat = 2
    @Published var randomKick = 20
    @Published var snareBeat = 2
    @Published var randomSnare = 20
    
    init(){
        let mixer = Mixer([kick, snare])
        output = Reverb(mixer)
        
        loop = CallbackLoop(every: 0.1) {
            let randKick = Array(0...self.randomKick).randomElement() == 0
            if self.counter % Int(64 / self.kickBeat) == 0 || randKick {
                let randomVelocity = MIDIVelocity(AUValue.random(in: 0...127))
                self.kick.play(noteNumber: 60, velocity: randomVelocity)
                self.kick.stop(noteNumber: 60)
            }
            
            let randSnare = Array(0...self.randomSnare).randomElement() == 0
            if self.counter % Int(64 / self.snareBeat) == 0 || randSnare {
                let randomVelocity = MIDIVelocity(AUValue.random(in: 0...127))
                self.snare.play(noteNumber: 60, velocity: randomVelocity, channel: 0)
                self.snare.stop(noteNumber: 60)
            }
            
            self.counter += 1
        }
    }
    
    func start() {
        loop?.start()
    }
    
    func stop() {
        loop?.stop()
    }
}

struct DrumSynthView: View {
    @ObservedObject var drumSynth:DrumSynth
    let screenSize = UIScreen.main.bounds
    @State var drumColor = UIColor(hue: 0.5, saturation: 1, brightness: 1, alpha: 1)
    @State var snareColor = UIColor(hue: 0.7, saturation: 1, brightness: 1, alpha: 1)
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color(drumColor))
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({value in
                            let x = value.location.x
                            let y = value.location.y
                            
                            drumSynth.kickBeat = drumSynth.beats[Int((x / screenSize.width) * CGFloat(drumSynth.beats.count))]
                            drumSynth.randomKick = Int((y / (screenSize.height * 0.5)) * 20)
                            
                            let hue = 0.5 + (x / screenSize.width) * 0.1
                            let brightness = 1 - (y / (screenSize.height * 0.5))
                            drumColor = UIColor(hue: hue, saturation: 1, brightness: brightness, alpha: 1)
                        })
                )
            Rectangle()
                .fill(Color(snareColor))
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({value in
                            let x = value.location.x
                            let y = value.location.y
                            
                            drumSynth.snareBeat = drumSynth.beats[Int((x / screenSize.width) * CGFloat(drumSynth.beats.count))]
                            drumSynth.randomSnare = Int((y / (screenSize.height * 0.5)) * 20)
                            
                            let hue = 0.7 + (x / screenSize.width) * 0.1
                            let brightness = 1 - (y / (screenSize.height * 0.5))
                            snareColor = UIColor(hue: hue, saturation: 1, brightness: brightness, alpha: 1)
                        })
                )
        }
        .onAppear(){
            drumSynth.start()
        }
        .onDisappear(){
            drumSynth.stop()
        }
    }
}

struct DrumSynthView_Previews: PreviewProvider {
    static var previews: some View {
        DrumSynthView(drumSynth: DrumSynth())
    }
}
