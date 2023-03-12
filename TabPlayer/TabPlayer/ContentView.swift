//
//  ContentView.swift
//  TabPlayer
//
//  Created by Akito van Troyer on 2/25/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var controller = DrumController()
    
    var body: some View {
        TabView {
            DrumSynthView(drumSynth: controller.drumSynth!)
                .tabItem {
                    Image(systemName: "rectangle.grid.1x2.fill")
                    Text("Drum Synth")
                }
            DrumPadView(drumPad: controller.drumPad!)
                .tabItem {
                    Image(systemName: "square.grid.3x3.fill")
                    Text("Drum Pad")
                }
            WebView()
                .tabItem {
                    Image(systemName: "network")
                    Text("Web")
                }
        }
        .onAppear(){
            controller.start()
        }
        .onDisappear(){
            controller.stop()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
