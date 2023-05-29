//
//  GeniusGauge.swift
//  GeniusWatch Watch App
//
//  Created by James Anyanwu on 29/05/2023.
//

import SwiftUI

struct GeniusGauge: View {
    
    var min: String = "0"
    var max: String = "100"
    let current: Float
    var title = ""
    let gradient = Gradient(colors: [.red, .pink, .yellow, .blue, .green])
    var body: some View {
        Gauge(value: current) {
            
        } currentValueLabel: {
            Text("\(Int(current))")
        } minimumValueLabel: {
            Text("\(min)")
        } maximumValueLabel: {
            Text("\(max)")
        }
        .gaugeStyle(CircularGaugeStyle(tint: gradient))
        
    }
}
