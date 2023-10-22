//
//  RandomWorkoutGeneratorApp.swift
//  RandomWorkoutGenerator
//
//  Created by Amro Salha on 10/22/23.
//

import SwiftUI

@main
struct RandomWorkoutGeneratorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
