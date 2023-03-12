//
//  MotionController.swift
//  MotionSynth
//
//  Created by Akito van Troyer on 3/12/21.
//

import SwiftUI
import CoreMotion

struct MotionData {
    var accelX:Double = 0
    var accelY:Double = 0
    var accelZ:Double = 0
    var gyroX:Double = 0
    var gyroY:Double = 0
    var gyroZ:Double = 0
    var roll:Double = 0
    var pitch:Double = 0
    var yaw:Double = 0
}

class MotionController : ObservableObject {
    let motionManager = CMMotionManager()
    @Published var data = MotionData()
    let motionSynth = MotionSynth()
    var timer:Timer!
    
    @Published var position:CGPoint = .zero
    @Published var rotationAngle:CGFloat = 0
    let screenSize = UIScreen.main.bounds
    
    init(){
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startDeviceMotionUpdates()
    }
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        motionSynth.start()
    }
    
    func stop() {
        timer.invalidate()
        motionSynth.stop()
    }
    
    func startSound() {
        motionSynth.startSound()
    }
    
    func stopSound() {
        motionSynth.stopSound()
    }
    
    @objc func update() {
        if let accelData = motionManager.accelerometerData {
            data.accelX = accelData.acceleration.x
            data.accelY = accelData.acceleration.y
            data.accelZ = accelData.acceleration.z
        }
        
        if let gyroData = motionManager.gyroData {
            data.gyroX = gyroData.rotationRate.x
            data.gyroY = gyroData.rotationRate.y
            data.gyroZ = gyroData.rotationRate.z
        }
        
        if let deviceMotion = motionManager.deviceMotion {
            data.roll = deviceMotion.attitude.roll
            data.pitch = deviceMotion.attitude.pitch
            data.yaw = deviceMotion.attitude.yaw
            trackAttitude(attitude: deviceMotion.attitude)
            motionSynth.setFilter(roll: deviceMotion.attitude.roll, pitch: deviceMotion.attitude.pitch)
            motionSynth.setModulationIndex(yaw: deviceMotion.attitude.yaw)
        }
    }
    
    func trackAttitude(attitude: CMAttitude){
        
        // Scale attitude
        // roll is in the range of -1.5 ~ 1.5
        // 0 when the device is flat
        // 1.5 when the device is 90º to left
        let maxRadius = screenSize.width / 2
        position.x = scale(num: CGFloat(attitude.roll), minNum: -1.5, maxNum: 1.5, scaleMin: -maxRadius, scaleMax: maxRadius)
        position.y = scale(num: CGFloat(attitude.pitch), minNum: -1.5, maxNum: 1.5, scaleMin: -maxRadius, scaleMax: maxRadius)
        rotationAngle = CGFloat(attitude.yaw)
    }
    
    func scale(num: CGFloat, minNum: CGFloat, maxNum: CGFloat, scaleMin: CGFloat, scaleMax: CGFloat) -> CGFloat {
        if (num <= minNum) {return scaleMin}
        if (num >= maxNum) {return scaleMax}
        return (num-minNum)/(maxNum-minNum) * (scaleMax-scaleMin) + scaleMin
    }
}
