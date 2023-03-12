//
//  SceneKitViewController.swift
//  3DDrumSequencer
//
//  Created by Akito van Troyer on 4/17/21.
//

import SceneKit
import SwiftUI
import AVFoundation

class SceneKitViewController: UIViewController {

    var scnView:SCNView!
    var scene:SequencerScene = SequencerScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scnView = SCNView(frame: UIScreen.main.bounds)
        scnView.scene = scene
        scnView.backgroundColor = .black
        scnView.showsStatistics = true
        scnView.allowsCameraControl = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tap)
        self.view = scnView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stop()
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer){
        let location = recognizer.location(in: scnView)
        
        let hitResults = scnView.hitTest(location, options: nil)
        if hitResults.count > 0 {
            for hitResult in hitResults {
                let id = Int(hitResult.node.name!)
                let material = SCNMaterial()
                if scene.states[id! - 1] {//On
                    material.diffuse.contents = UIColor.gray
                }
                else {//Off
                    material.diffuse.contents = UIColor.red
                }
                //Apply Color
                scene.spheres[id! - 1].materials = [material]
                //Toggle the state
                scene.states[id! - 1] = !scene.states[id! - 1]
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let position = scnView.pointOfView!.position
        scene.setPan(position: AUValue(position.x) / (Float.pi * 2))
    }
    
    func start(){
        scene.start()
    }
    
    func stop(){
        scene.stop()
    }
}


// MARK: - SceneKitViewControllerContainer
struct SceneKitViewControllerContainer: UIViewControllerRepresentable {
    typealias UIViewControllerType = SceneKitViewController
    
    func makeUIViewController(context: Context) -> SceneKitViewController {
        let controller = SceneKitViewController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SceneKitViewController, context: Context) {}
}
