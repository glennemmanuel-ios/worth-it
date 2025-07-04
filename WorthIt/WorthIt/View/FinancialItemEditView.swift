//
//  FinancialItemEditView.swift
//  WorthIt
//
//  Created by Glen Emmanuel Solo on 7/4/25.
//

import SwiftUI

struct FinancialItemEditView: View {
    
    @State private var selectedType = FinancialItem.AccountType.asset(.liquidAsset)
    @State private var selectedCategory: String?
    @State private var name = ""
    @State private var amount: Double = 0.0
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            Picker("Type", selection: $selectedType) {
                Text(FinancialItem.AccountType.asset(.liquidAsset).stringValue)
                    .tag(FinancialItem.AccountType.asset(.liquidAsset))
                Text(FinancialItem.AccountType.liability(.others).stringValue)
                    .tag(FinancialItem.AccountType.liability(.others))
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedType) {
                selectedCategory = nil
            }
            TextField("Amount", text: .constant(""))
                .keyboardType(.decimalPad)
            Picker("Category", selection: $selectedCategory) {
                ForEach(selectedType.categories, id: \.self) {
                    Text($0)
                        .tag($0)
                }
            }
        }.navigationTitle("Create New Financial Item")
    }
}

#Preview {
    FinancialItemEditView()
}
