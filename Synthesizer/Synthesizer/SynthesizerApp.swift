//
//  SynthesizerApp.swift
//  Synthesizer
//
//  Created by Akito van Troyer on 1/23/21.
//

import SwiftUI

@main
struct SynthesizerApp: App {
    var body: some Scene {
        WindowGroup {
            // Force the app to use light mode
            // with environment and prefrredColorScheme methods
            ContentView()
                .environment(\.colorScheme, .light)
                .preferredColorScheme(.light)
        }
    }
}
