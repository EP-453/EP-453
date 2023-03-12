//
//  SeqeuncerScene.swift
//  3DDrumSequencer
//
//  Created by Akito van Troyer on 4/17/21.
//

import SceneKit
import AVFoundation

class SequencerScene: SCNScene {
    var radius:CGFloat = 0.2
    let columns = 16
    var rows = 4
    var spheres = [SCNSphere]()
    var states:[Bool]!
    var curBeat = 0
    var audioPlayer = Player()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        rows = audioPlayer.getNumPlayers()
        
        addSpheres()
        //Initialize states with false to begin with
        states = [Bool].init(repeating: false, count: rows*columns)

        //Set up a light
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 0, y: 0, z: 10.5)
        self.rootNode.addChildNode(lightNode)

        //Create Camera
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0.0, y: 0.0, z: 5.0)
        self.rootNode.addChildNode(cameraNode)

        //Set up ambient light
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        cameraNode.light = ambientLight

        //Run a timer to update the scene
        Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    @objc func tick(){
        let cursorMaterial = SCNMaterial()
        cursorMaterial.diffuse.contents = UIColor.yellow
        let offMaterial = SCNMaterial()
        offMaterial.diffuse.contents = UIColor.gray
        let onMaterial = SCNMaterial()
        onMaterial.diffuse.contents = UIColor.red
        
        for row in 0..<rows {
            //Trigger sound
            if states[row*columns+curBeat] {
                audioPlayer.playSound(index: row)
            }
            
            //Increment cursor
            spheres[row*columns+curBeat].materials = [cursorMaterial]
            //Fix the states for previous cursor
            if row*columns+curBeat == 0 {
                if states[rows*columns-1] {
                    spheres[rows*columns-1].materials = [onMaterial]
                }
                else {
                    spheres[rows*columns-1].materials = [offMaterial]
                }
            }
            else{
                if states[row*columns+curBeat-1] {
                    spheres[row*columns+curBeat-1].materials = [onMaterial]
                }
                else {
                    spheres[row*columns+curBeat-1].materials = [offMaterial]
                }
            }
        }
        
        curBeat = (curBeat + 1) % columns
    }
    
    func addSpheres(){
        var y:CGFloat = 0.0
        let yOffset = CGFloat(rows) * radius
        let xOffset = CGFloat(columns) * radius
        for row in 0..<rows {
            var x:CGFloat = 0.0
            for column in 0..<columns {
                let sphereGeometry = SCNSphere(radius: radius)
                
                let sphereNode = SCNNode(geometry: sphereGeometry)
                sphereNode.position = SCNVector3(x-xOffset, -y+yOffset, 0.0)
                sphereNode.name = String(row*columns+column+1)
                
                let redMaterial = SCNMaterial()
                redMaterial.diffuse.contents = UIColor.gray
                sphereGeometry.materials = [redMaterial]
                
                self.rootNode.addChildNode(sphereNode)
                spheres.append(sphereGeometry)
                
                x += 2 * radius
            }
            y += 2 * radius
        }
    }
    

    func setPan(position: AUValue) {
        audioPlayer.setPan(position: position)
    }
    
    func start(){
        audioPlayer.start()
    }
    
    func stop(){
        audioPlayer.stop()
    }
}
