//
//  ContentView.swift
//  GeniusWatch Watch App
//
//  Created by James Anyanwu on 29/05/2023.
//

import SwiftUI
import HealthKit
import WatchKit

struct ContentView: View {
    @State private var healthGauge: Double = 0.0
    @State private var currentTime: String = ""
    @State private var batteryLevel: Float = 0.0
    @State private var heartRate: Double = 0.0

    let healthStore = HKHealthStore()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss a"
        return formatter
    }()

    private func updateTime() {
        currentTime = timeFormatter.string(from: Date())
    }

    private func updateHeartRate() {
        guard let heartRateType = HKSampleType.quantityType(forIdentifier: .heartRate) else { return }

        let query = HKSampleQuery(sampleType: heartRateType,
                                  predicate: nil,
                                  limit: 1,
                                  sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, _ in
            if let heartRateSample = samples?.first as? HKQuantitySample {
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let value = heartRateSample.quantity.doubleValue(for: heartRateUnit)
                heartRate = value
            }
        }
        healthStore.execute(query)
    }
    
    private func updateBatteryLevel() {
        batteryLevel = WKInterfaceDevice.current().batteryLevel * -100
    }

    var body: some View {
        VStack {
            GeniusGauge(current: Float(healthGauge))
            GeniusText(title: "Health", value: "\(healthGauge)")
            GeniusText(title: "Time", value: "\((currentTime))")
            GeniusGauge(current: Float(batteryLevel))
            GeniusText(title: "Battery", value: "\(Int(batteryLevel))%")
        }
        .onAppear {

            let typesToShare: Set<HKSampleType> = []
            let typesToRead: Set<HKSampleType> = [.audiogramSampleType(), .electrocardiogramType(), .workoutType()]

            healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
                if success {
                    updateHeartRate()
                }
                if let error {
                    print(error)
                }
            }
        
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                updateTime()
                updateBatteryLevel()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
