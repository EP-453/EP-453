//
//  XYPad.swift
//  Navigation
//
//  Created by Akito van Troyer on 1/31/21.
//

import SwiftUI
import AudioKit

struct XYPadView: View {
    @ObservedObject var controller:ProcessorController
    let screenSize = UIScreen.main.bounds
    @State private var currentPosition: CGSize = .zero
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color.red)
                .frame(width: 50, height: 50)
                .offset(x: self.currentPosition.width, y: self.currentPosition.height)
        }
        .frame(width: screenSize.width, height: screenSize.height)
        .background(Color.black)
        .gesture(
            DragGesture(minimumDistance: 0).onChanged{ value in
                let x = value.location.x
                let y = value.location.y
                
//                print(x,y, screenSize.width, screenSize.height)
                self.currentPosition = CGSize(width: x - screenSize.width * 0.5, height: value.location.y - screenSize.height * 0.5)
                controller.lpf?.cutoffFrequency = AUValue(x / screenSize.width) * Float(Settings.sampleRate * 0.125)
                controller.lpf?.resonance = AUValue(y / screenSize.height) * 20
            })
        .navigationBarTitle("XYPad")
    }
}

struct XYPadView_Previews: PreviewProvider {
    static var previews: some View {
        XYPadView(controller: ProcessorController())
    }
}
