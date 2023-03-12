//
//  ProcessorView.swift
//  Navigation
//
//  Created by Akito van Troyer on 2/4/21.
//

import SwiftUI
import Sliders

struct ProcessorView: View {
    @ObservedObject var controller:ProcessorController
    var body: some View {
        VStack {
            //Distortion
            HStack{
                Text("Distortion")
                    .padding()
                Spacer()
                Text("\(controller.decimation, specifier: "%0.2f")")
                    .padding()
            }
            ValueSlider(value: $controller.decimation, in: controller.decimationRange)
                .valueSliderStyle(HorizontalValueSliderStyle(
                    thumbSize: CGSize(width: 20, height: 20),
                    thumbInteractiveSize: CGSize(width: 44, height: 44)))
                .padding()
                .frame(height: 50)

            //Reverb
            HStack{
                Text("Reverb")
                    .padding()
                Spacer()
                Text("\(controller.dryWet, specifier: "%0.2f")")
                    .padding()

            }
            ValueSlider(value: $controller.dryWet, in: controller.dryWetRange)
                .valueSliderStyle(HorizontalValueSliderStyle(
                    thumbSize: CGSize(width: 20, height: 20),
                    thumbInteractiveSize: CGSize(width: 44, height: 44)))
                .padding()
                .frame(height: 50)

            //Volume
            HStack{
                Text("Volume")
                    .padding()
                Spacer()
                Text("\(controller.gain, specifier: "%0.2f")")
                    .padding()
            }
            ValueSlider(value: $controller.gain, in: controller.gainRange)
                .valueSliderStyle(HorizontalValueSliderStyle(
                    thumbSize: CGSize(width: 20, height: 20),
                    thumbInteractiveSize: CGSize(width: 44, height: 44)))
                .padding()
                .frame(height: 50)
        }
    }
}

struct ProcessorView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessorView(controller: ProcessorController())
    }
}
