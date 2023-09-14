//
//  ContentView.swift
//  iExpense
//
//  Created by Peter Werner on 20.03.23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpenses = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text(item.amount, format: .currency(code: "EUR"))
                    }
                }.onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar(content: {
                Button {
                    showingAddExpenses = true
                } label: {
                    Image(systemName: "plus")
                }
            })
            .sheet(isPresented: $showingAddExpenses, content: {
                AddView(expenses: expenses)
            })
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
