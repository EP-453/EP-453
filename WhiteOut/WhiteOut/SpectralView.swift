//
//  SpectralView.swift
//  WhiteOut
//
//  Created by Akito van Troyer on 4/2/21.
//

import SwiftUI

struct SpectralView : View {
    @ObservedObject var controller = WhiteOutController()
    @State var currentPosition:CGPoint = .zero
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            HStack(spacing: 0.0){
                ForEach(0..<controller.amplitudes.count) { number in
                    MeterView(amplitude: $controller.amplitudes[number])
                }
            }
            Circle()
                .fill(Color(red: 1, green: 0, blue: 0, opacity: 0.6))
                .frame(width: 50, height: 50)
                .offset(x: self.currentPosition.x, y: self.currentPosition.y)
        }
        .background(Color.black)
        .frame(width:screenSize.width, height: screenSize.height)
        .gesture(DragGesture(minimumDistance: 0).onChanged{ value in
            let x = value.location.x
            self.currentPosition = CGPoint(x: x - screenSize.width * 0.5, y: value.location.y - screenSize.height * 0.5)
            let location = CGPoint(x: value.location.x / screenSize.width, y: value.location.y / screenSize.height)
            controller.location = location
        })
        .onAppear(){
            controller.start()
        }
        .onDisappear(){
            controller.stop()
        }
        .alert(isPresented: $controller.warn){
            Alert(title: Text("Feedback Warning!"), message: Text("Without headphones plugged in, you may experience feedback!"), dismissButton: .default(Text("OK")))
        }
    }
}

struct MeterView: View {
    @Binding var amplitude:Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top){
                //Rectangle for displaying amplitude
                Rectangle()
                    .fill(Color.white)
                    .frame(height: geometry.size.height - (geometry.size.height * (1.0 - CGFloat(amplitude))))
                    .offset(x: 0, y: geometry.size.height * (1.0 - CGFloat(amplitude)))
                    .animation(.easeOut(duration: 0.1))
            }
            .padding(geometry.size.width * 0.1)
            .border(Color.black, width: geometry.size.width * 0.1)
        }
    }
}

