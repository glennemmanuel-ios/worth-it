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
    
    @Query private var allItems: [FinancialItem]
    
    @Query(filter: #Predicate<FinancialItem> {
        $0.typeRaw == "asset"
    })
    private var assets: [FinancialItem]
    
    @Query(filter: #Predicate<FinancialItem> {
        $0.typeRaw == "liability"
    })
    private var liabilities: [FinancialItem]
    
    @StateObject private var viewModel = ViewModel()
    @State private var showDetail = false
    @State private var selectedFilter: Filter = .all
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.secondary)
                        .shadow(radius: 8)
                        .overlay {
                            VStack {
                                Text("Total Net Worth")
                                    .foregroundStyle(Color(.white))
                                    .fontWeight(.semibold)
                                Text(getTotalNetWorth().formatted())
                                    .foregroundStyle(Color(.white))
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                        }
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.green)
                            .shadow(radius: 8)
                            .overlay {
                                VStack {
                                    Text("Assets")
                                        .foregroundStyle(Color(.white))
                                        .fontWeight(.semibold)
                                    Text(getTotal(.assets).formatted())
                                        .foregroundStyle(Color(.white))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                            }
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.red)
                            .overlay {
                                VStack {
                                    Text("Liabilities")
                                        .foregroundStyle(Color(.white))
                                        .fontWeight(.semibold)
                                    Text(getTotal(.liabilities).formatted())
                                        .foregroundStyle(Color(.white))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                            }
                    }
                }
                .padding()
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(Filter.allCases, id: \.self) { filter in
                        Text(filter.displayString)
                            .tag(filter.displayString)
                    }
                }
                .padding()
                .pickerStyle(.segmented)
                List {
                    ForEach(getList()) { item in
                        VStack(alignment: .leading) {
                            Text(item.label)
                            Text(item.formattedAmount)
                                .foregroundStyle(item.type == .liability ? Color(.red) : Color(.green))
                            Text(item.category ?? "N/A")
                        }
                    }
                    .onDelete { indices in
                        for index in indices {
                            deleteItem(assets[index])
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
            .navigationTitle("My Net Worth")
        }
    }
    
    private func deleteItem(_ item: FinancialItem) {
        modelContext.delete(item)
        try? modelContext.save()
    }
    
    private func getList() -> [FinancialItem] {
        switch selectedFilter {
        case .all:
            return allItems
        case .assets:
            return assets
        case .liabilities:
            return liabilities
        }
    }
    
    private func getTotalNetWorth() -> Double {
        let totalAssets = getTotal(.assets)
        let totalLiabilities = getTotal(.liabilities)
        let totalNetWorth = totalAssets - totalLiabilities
        return totalNetWorth
    }
    
    private func getTotal(_ filter: Filter) -> Double {
        var items = [FinancialItem]()
        var totalAmount = 0.0
        switch filter {
        case .assets:
            items = self.assets
        case .liabilities:
            items = self.liabilities
        default:
            break
        }
        items.forEach { item in
            totalAmount += item.amount
        }
        return totalAmount
    }
    
}

extension DashboardView {
    
    enum Filter: String, CaseIterable, Codable, Hashable, Equatable {
        case all
        case assets
        case liabilities
        
        var displayString: String {
            switch self {
            case .all: return "All"
            case .assets: return "Assets"
            case .liabilities: return "Liabilities"
            }
        }
    }
    
}


#Preview {
    DashboardView()
        .modelContainer(for: FinancialItem.self, inMemory: true)
}
