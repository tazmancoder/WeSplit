//
//  ContentView.swift
//  WeSplit
//
//  Created by Mark Perryman on 5/7/22.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool

    let tipPercentages = [10, 15, 20, 25, 0]

    var formatCheckAmount: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currencyCode ?? "USD")
    }

    var totalCheckAmount: Double {
        let tipSelection = Double(tipPercentage)

        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue

        return grandTotal
    }

    var totalPerPerson: Double {
        let peopleCnt = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)

        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCnt

        return amountPerPerson
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Table Split") {
                    TextField("Check Amount", value: $checkAmount, format: formatCheckAmount)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)

                    Picker("Total in party", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }

                Section {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(0..<101, id: \.self) {
                            Text($0, format: .percent)
                                .foregroundColor(tipPercentage == 0 ? .red : .secondary)
                        }
                    }
                } header: {
                    Text("How much tip would you like to leave?")
                }

                Section("Total Check Amount") {
                    Text(totalCheckAmount, format: formatCheckAmount)
                }

                Section("Total Per Person") {
                    HStack {
                        Spacer()
                        Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                            .font(.system(size: 60, weight: .black, design: .rounded))
                            .foregroundColor(.green)
                        Spacer()
                    }
                    .frame(width: .infinity, height: 100, alignment: .center)
                }
            }
            .navigationTitle("We Split")
            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(action: { amountIsFocused = false }, label: {
                        Text("Done")
                    })
                }
            }
        }
    }
}

