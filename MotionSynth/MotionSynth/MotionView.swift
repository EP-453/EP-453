//
//  MotionView.swift
//  MotionSynth
//
//  Created by Akito van Troyer on 3/12/21.
//

import SwiftUI

struct MotionView: View {
    @ObservedObject var controller = MotionController()
    
    var body: some View {
        ZStack {
            TrackView(position: controller.position, rotationAngle: controller.rotationAngle)
            VStack {
                SensorView(name: "Accel X:", value: controller.data.accelX)
                SensorView(name: "Accel Y:", value: controller.data.accelY)
                SensorView(name: "Accel Z:", value: controller.data.accelZ)
                SensorView(name: "Gyro X:", value: controller.data.gyroX)
                SensorView(name: "Gyro Y:", value: controller.data.gyroY)
                SensorView(name: "Gyro Z:", value: controller.data.gyroZ)
                SensorView(name: "Pitch:", value: controller.data.pitch)
                SensorView(name: "Roll:", value: controller.data.roll)
                SensorView(name: "Yaw:", value: controller.data.yaw)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0).onChanged({ _ in
                controller.startSound()
            })
            .onEnded({ _ in
                controller.stopSound()
            })
        )
        .onAppear(){
            controller.start()
        }
        .onDisappear(){
            controller.stop()
        }
    }
}

struct SensorView: View {
    var name:String
    var value:Double
    
    var body: some View {
        HStack {
            Spacer()
            Text(name)
                .padding()
            Spacer()
            Text("\(value, specifier: "%.03f")")
                .padding()
                .frame(width: 100)
            Spacer()
        }
    }
}

struct TrackView: View {
    let screenSize = UIScreen.main.bounds
    var position: CGPoint
    var rotationAngle: CGFloat
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.init(hue: 1, saturation: 1, brightness: 1, opacity: 0.6))
                .frame(width: 50, height: 50)
                .offset(x: self.position.x, y: self.position.y)
                .transformEffect(
                    CGAffineTransform(rotationAngle: rotationAngle)
                        .translatedBy(x: self.position.x - 25, y: self.position.y - 25)
                )
        }
        .frame(width: screenSize.width, height: screenSize.height)
    }
}

struct MotionView_Previews: PreviewProvider {
    static var previews: some View {
        MotionView()
    }
}
