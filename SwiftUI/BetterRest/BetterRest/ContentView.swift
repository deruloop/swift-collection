//
//  ContentView.swift
//  BetterRest
//
//  Created by Cristiano Calicchia on 18/09/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = [1,2,3,4,5,6,7,8,9,10]
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var coffeeNumber = 0
    
    var reccomendedBedtime: String {
        let recommended = calculateBedtime()
        
        return recommended
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    /*Text("When do you want to wake up?")
                        .font(.headline)*/
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Desired amount of sleep")) {
                    /*Text("Desired amount of sleep")
                        .font(.headline)*/
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                    .accessibility(value: Text("\(sleepAmount, specifier: "%g") hours"))
                }
                
                Section(header: Text("Daily coffee intake")) {
                    /*Text("Daily coffee intake")
                        .font(.headline)*/
                    
                    Picker("Coffee Amount", selection: $coffeeNumber) {
                        ForEach(0 ..< coffeeAmount.count) {
                            if $0 == 0 {
                                Text("\(self.coffeeAmount[$0]) cup")
                            } else {
                                Text("\(self.coffeeAmount[$0]) cups")
                            }
                        }
                    }
                    /*Stepper(value: $coffeeAmount, in: 1...20) {
                        
                        if coffeeAmount == 1 {
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount) cups")
                        }*/
                    }
                
                Text("Reccomendend bedtime is \(reccomendedBedtime)")
                    .font(.headline)
                }
                
            }
            .navigationBarTitle("BetterRest")
            /*.navigationBarItems(trailing:
                Button(action: calculateBedtime) {
                    Text("Calculate")
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }*/
        }
    
    func calculateBedtime() -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        let model = SleepCalculator()
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount[coffeeNumber]))

            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short

            
            /*alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is…"*/
            return formatter.string(from: sleepTime)
            
        } catch {
            /*alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."*/
            return ""
        }
        
        //showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
