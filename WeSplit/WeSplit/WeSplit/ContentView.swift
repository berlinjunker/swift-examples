//
//  ContentView.swift
//  WeSplit
//
//  Created by Peter Werner on 17.02.23.
//

import SwiftUI

struct TipModifier: ViewModifier {
    let tipPercentage: Int
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(tipPercentage == 0 ? .red : .black)
    }
}

extension View {
    func noTipGiven(tipPercentage: Int) -> some View {
        self.modifier(TipModifier(tipPercentage: tipPercentage))
    }
}

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let amountPerPerson = totalAmountForCheck / peopleCount
        return amountPerPerson
    }
    
    var totalAmountForCheck: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        return grandTotal
    }
    
    let currency = FloatingPointFormatStyle<Double>.Currency(code: "EUR")
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: currency)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    Picker("Number of People", selection: $numberOfPeople, content: {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    })
                }
                
                Section {
                    Picker("Tip percentage", selection: $tipPercentage, content: {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }).pickerStyle(.segmented)
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    Text(totalPerPerson, format: currency)
                } header: {
                    Text("Amount per person")
                }
                
                Section {
                    Text(totalAmountForCheck, format: currency)
                } header: {
                    Text("Total Amount for the check (+ tip)")
                        //.foregroundColor(tipPercentage == 0 ? .red : .black)
                        .noTipGiven(tipPercentage: tipPercentage)
                }
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.large)
            .toolbar() {
                ToolbarItemGroup(placement: .keyboard, content: {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
