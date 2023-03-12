//
//  WebView.swift
//  TabPlayer
//
//  Created by Akito van Troyer on 2/25/21.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    typealias UIViewType = WKWebView
    let url = "https://tonejs.github.io/examples/fmSynth"
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        context.coordinator.load(url: URL(string: url)!, view: uiView)
    }
}

class Coordinator: NSObject {
    var parent: WebView
    
    init(_ parent: WebView) {
        self.parent = parent
    }
    
    func load(url: URL, view: WKWebView) {
        let request = URLRequest(url: url)
        view.load(request)
    }
}
