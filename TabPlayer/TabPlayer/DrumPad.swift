//
//  DrumPad.swift
//  TabPlayer
//
//  Created by Akito van Troyer on 2/25/21.
//

import SwiftUI
import AVFoundation
import AudioKit

class DrumPad: ObservableObject {
    @Published var padStates = [Bool]()
    var players = [AppleSampler]()
    
    init() {
        let files = Bundle.main.paths(forResourcesOfType: "wav", inDirectory: "Samples")
        
        do {
            for file in files {
                let audioFile = try AVAudioFile(forReading: URL(string: file)!)
                let player = AppleSampler()
                try player.loadAudioFile(audioFile)
                padStates.append(false)
                players.append(player)
            }
        }
        catch let error {
            print("Cannot read audio file: ", error)
        }
    }
    
    func play(id: Int){
        try? players[id].play()
    }
}

struct DrumPadView: View {
    @ObservedObject var drumPad:DrumPad
    var rows = 4
    var columns = 3
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        Rectangle()
                            .fill(Color(drumPad.padStates[row * columns + column] ? .gray : .red))
                            .gesture(
                                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                    .onChanged({_ in
                                        if !drumPad.padStates[row * columns + column] {
                                            drumPad.padStates[row * columns + column] = true
                                            drumPad.play(id: row * columns + column)
                                        }
                                    })
                                    .onEnded({_ in
                                        drumPad.padStates[row * columns + column] = false
                                    })
                            )
                    }
                }
            }
        }
    }
}

struct DrumPadViewView_Previews: PreviewProvider {
    static var previews: some View {
        DrumPadView(drumPad: DrumPad())
    }
}
