//
//  DashboardView.swift
//  WorthIt
//
//  Created by Glen Emmanuel Solo on 7/4/25.
//

import SwiftUI
import SwiftData

struct DashboardView: View {

    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<FinancialItem> {
        $0.typeRaw == "asset"
    })
    var assets: [FinancialItem]
    
    @Query(filter: #Predicate<FinancialItem> {
        $0.typeRaw == "liability"
    })
    var liabilities: [FinancialItem]
    
    @StateObject private var viewModel = ViewModel()
    @State private var showDetail = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Assets")) {
                        ForEach(assets) { item in
                            VStack(alignment: .leading) {
                                Text(item.label)
                                Text(item.formattedAmount)
                                Text(item.type.stringValue)
                                Text(item.category ?? "N/A")
                            }
                        }
                        .onDelete { indices in
                            for index in indices {
                                deleteItem(assets[index])
                            }
                        }
                    }
                    Section(header: Text("Liabilities")) {
                        ForEach(liabilities) { item in
                            VStack(alignment: .leading) {
                                Text(item.label)
                                Text(item.formattedAmount)
                                Text(item.type.stringValue)
                                Text(item.category ?? "N/A")
                            }
                        }
                        .onDelete { indices in
                            for index in indices {
                                deleteItem(liabilities[index])
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        showDetail = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showDetail) {
                FinancialItemEditView()
            }
        }
    }
    
    private func deleteItem(_ item: FinancialItem) {
        modelContext.delete(item)
        try? modelContext.save()
    }
    
}

#Preview {
    DashboardView()
        .modelContainer(for: FinancialItem.self, inMemory: true)
}
