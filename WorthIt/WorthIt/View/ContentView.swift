//
//  ContentView.swift
//  WorthIt
//
//  Created by Glen Emmanuel Solo on 7/4/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var items: [FinancialItem]
    @State private var showDetail = false
    
    var body: some View {
        NavigationStack {
            Text("Hello World")
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
}

#Preview {
    ContentView()
        .modelContainer(for: FinancialItem.self, inMemory: true)
}
