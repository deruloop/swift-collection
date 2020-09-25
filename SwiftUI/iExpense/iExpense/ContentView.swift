//
//  ContentView.swift
//  iExpense
//
//  Created by Cristiano Calicchia on 24/09/2020.
//

import SwiftUI

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(items) {
                    UserDefaults.standard.set(encoded, forKey: "Items")
                }
            }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }

        self.items = []
    }
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(expenses.items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            
                            Spacer()
                            Text("$\(item.amount)")
                                .overlay(Text("$\(item.amount)").foregroundColor(item.amount<10 ? .blue : .clear))
                                .overlay(Text("$\(item.amount)").foregroundColor(item.amount>10 && item.amount<100 ? .green : .clear))
                                .overlay(Text("$\(item.amount)").foregroundColor(item.amount>100 ? .red : .clear))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading:
                                    EditButton(),
                                trailing:
                Button(action: {
                    self.showingAddExpense = true
                }) {
                    Image(systemName: "plus")
                })
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: self.expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
