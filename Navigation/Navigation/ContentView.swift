//
//  ContentView.swift
//  Navigation
//
//  Created by Akito van Troyer on 1/29/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var controller = ProcessorController()
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                ProcessorView(controller: controller)
                    .navigationBarTitle("Processor")
                Spacer()
                NavigationLink(
                    destination: XYPadView(controller: controller)){
                    Text("Go to XYPad Control >")
                        .padding()
                }
            }
        }
        .onAppear(){
            self.controller.start()
        }
        .onDisappear(){
            self.controller.stop()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
