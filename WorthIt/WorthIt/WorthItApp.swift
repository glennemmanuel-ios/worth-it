//
//  WorthItApp.swift
//  WorthIt
//
//  Created by Glen Emmanuel Solo on 7/4/25.
//

import SwiftUI
import SwiftData

@main
struct WorthItApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FinancialItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
