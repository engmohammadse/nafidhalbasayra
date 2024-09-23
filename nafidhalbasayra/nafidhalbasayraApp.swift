//
//  nafidhalbasayraApp.swift
//  nafidhalbasayra
//
//  Created by muhammad on 23/09/2024.
//

import SwiftUI

@main
struct nafidhalbasayraApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
