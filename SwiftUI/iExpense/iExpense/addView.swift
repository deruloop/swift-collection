//
//  addView.swift
//  iExpense
//
//  Created by Cristiano Calicchia on 25/09/2020.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @ObservedObject var expenses: Expenses
    @State private var wrongValue = false

    static let types = ["Business", "Personal"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save") {
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    wrongValue = true
                }
            })
        }
        .alert(isPresented: $wrongValue) {
            Alert(title: Text("Wrong value!"), message: Text("\(amount) is not a number!"), dismissButton: .default(Text("Continue")))
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
