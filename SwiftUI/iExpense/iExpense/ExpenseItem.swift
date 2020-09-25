//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Cristiano Calicchia on 25/09/2020.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}
