//
//  FinancialItemEditView.swift
//  WorthIt
//
//  Created by Glen Emmanuel Solo on 7/4/25.
//

import SwiftUI

struct FinancialItemEditView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var selectedType: FinancialItem.AccountType = .asset
    @State private var selectedCategory: String = "None"
    @State private var name = ""
    @State private var amount: Double = 0.0
    
    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "PHP"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }
    
    var body: some View {
        Form {
            Section("Add New Entry") {
                TextField("Name", text: $name)
                Picker("Type", selection: $selectedType) {
                    ForEach(FinancialItem.AccountType.allCases, id: \.self) { type in
                        Text(type.stringValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedType) {
                    selectedCategory = "None"
                }
                TextField("Amount", value: $amount, formatter: formatter)
                    .keyboardType(.decimalPad)
                Picker("Category", selection: $selectedCategory) {
                    Text("None").tag("None")
                    ForEach(selectedType.categories, id: \.self) {
                        Text($0)
                            .tag($0)
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                saveItem()
            } label: {
                Text("SAVE")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 18, weight: .bold))
            }
            .buttonStyle(.glassProminent)
            .padding([.horizontal, .bottom])
        }
    }
    
    private func saveItem() {
        let item = FinancialItem(
            label: name,
            type: selectedType,
            amount: amount,
            category: selectedCategory)
        
        context.insert(item)
        dismiss()
    }
    
}

#Preview {
    FinancialItemEditView()
}
