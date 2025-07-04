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
    
    var body: some View {
        NavigationView {
            Text("Hello World")
            .toolbar {
                ToolbarItem {
                    Button {
                        print("Add button tapped.")
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: FinancialItem.self, inMemory: true)
}
