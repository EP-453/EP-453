//
//  ContentView.swift
//  BeatBounce
//
//  Created by Akito van Troyer on 4/5/21.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var screenSize = UIScreen.main.bounds
    let beatBounceScene = BeatBounceScene()
    
    var scene: SKScene {
        beatBounceScene.size = CGSize(width: screenSize.width, height: screenSize.height)
        //Scale the scene to fill the screen
        beatBounceScene.scaleMode = .fill
        
        //Set up the view
        beatBounceScene.view?.ignoresSiblingOrder = true
        beatBounceScene.view?.showsFPS = true
        beatBounceScene.view?.showsNodeCount = true
        
        return beatBounceScene
    }
    
    var body: some View {
        SpriteView(scene: scene)
                    .frame(width: screenSize.width, height: screenSize.height)
                    .ignoresSafeArea()
            .onAppear(){
                (scene as! BeatBounceScene).start()
            }
            .onDisappear(){
                (scene as! BeatBounceScene).stop()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
