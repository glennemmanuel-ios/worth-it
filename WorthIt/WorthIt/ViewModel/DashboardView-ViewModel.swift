//
//  ContentView-ViewModel.swift
//  WorthIt
//
//  Created by Glen Emmanuel Solo on 10/16/25.
//

import Foundation
import SwiftData

extension DashboardView {
    
    @MainActor
    class ViewModel: ObservableObject {
        private var context: ModelContext?
        
        @Published var assets: [FinancialItem] = []
        @Published var liabilities: [FinancialItem] = []
        
        func setContext(_ context: ModelContext) {
            self.context = context
        }
        
        func fetchItem(by type: FinancialItem.AccountType) {
            let descriptor = FetchDescriptor<FinancialItem> (
                predicate: #Predicate { $0.typeRaw == type.rawValue }
            )
            
            do {
                switch type {
                case .asset:
                    assets = try context?.fetch(descriptor) ?? []
                case .liability:
                    liabilities = try context?.fetch(descriptor) ?? []
                }
            } catch {
                print("Fetch error: \(error)")
            }
        }
        
        func deleteItem(_ item: FinancialItem) {
            context?.delete(item)
        }
        
        func saveItem(_ item: FinancialItem) {
            context?.insert(item)
        }
        
    }
    
}
