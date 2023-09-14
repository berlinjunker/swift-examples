//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Peter Werner on 20.03.23.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
