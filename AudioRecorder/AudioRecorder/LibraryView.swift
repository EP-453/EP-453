//
//  LibraryView.swift
//  AudioRecorder
//
//  Created by Akito van Troyer on 3/26/21.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var controller = LibraryController()
    var body: some View {
        //List all recorded sound files
        List {
            ForEach(0..<controller.recordings.count, id: \.self) { index in
                Button(action: {controller.play(index: index)}){
                    Text(controller.recordings[index])
                }
            }
        }
        .onAppear(){
            controller.load()
            controller.start()
        }
        .onDisappear(){
            controller.stop()
        }
    }
}
