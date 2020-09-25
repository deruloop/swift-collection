//
//  ContentView.swift
//  WeSplit
//
//  Created by Cristiano Calicchia on 15/09/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = ""
    @State private var tipPercentage = 2
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        //let peopleCount = Double(numberOfPeople + 2)
        let peopleCount = Double(numberOfPeople) ?? 2
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount

        return amountPerPerson
    }
    
    var peopleCount:Double {
        let peopleCount = Double(numberOfPeople) ?? 0
        
        return peopleCount
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)

                    /*Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }*/
                    
                    TextField("N people", text: $numberOfPeople)
                        .keyboardType(.decimalPad)
                    
                }
                
                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
                
                Section(header: Text("Total Amount")) {
                    Text("$\(totalPerPerson*peopleCount, specifier: "%.2f")")
                        .foregroundColor(tipPercentage == 4 ? .red : .black)
                }
            }
            .navigationBarTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
