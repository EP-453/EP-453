//
//  ContentView.swift
//  3DDrumSequencer
//
//  Created by Akito van Troyer on 4/17/21.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    var screenSize = UIScreen.main.bounds
    var body: some View {
        SceneKitViewControllerContainer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
