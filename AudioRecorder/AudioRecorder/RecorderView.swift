//
//  RecorderView.swift
//  AudioRecorder
//
//  Created by Akito van Troyer on 3/26/21.
//

import SwiftUI

struct RecorderView: View {
    @ObservedObject var controller = RecorderController()
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
            NavigationView {
                VStack(alignment: .trailing){
                    //View recorded sound
                    NavigationLink(destination: LibraryView()){
                        Text("Recorded Sounds >")
                    }
                    .padding()
                        
                    Spacer()

                    //Start/stop recording
                    Button(action: {
                        controller.record()
                    }) {
                        Image(systemName: controller.isRecording ? "stop.fill" : "record.circle.fill" )
                            .font(.system(size: 60))
                            .frame(width: screenSize.width)
                    }
                
                    Spacer()
                    
                    //Choose the input source for recording
                    Picker(selection: $controller.audioSource, label: Text("Audio Source:")){
                        ForEach(0..<SourceType.allCases.count, id: \.self) { count in
                            Text(SourceType.allCases[count].rawValue)
                                .tag(SourceType.allCases[count])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
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

struct RecorderView_Preview : PreviewProvider {
    static var previews: some View {
        RecorderView()
    }
}
