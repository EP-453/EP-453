//
//  ContentView.swift
//  HelloSwift
//
//  Created by Akito van Troyer  on 1/16/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, Swift!")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color.red)
            .underline()
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
