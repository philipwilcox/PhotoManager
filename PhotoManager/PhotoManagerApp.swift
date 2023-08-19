//
//  PhotoManagerApp.swift
//  PhotoManager
//
//  Created by Philip Wilcox on 8/19/23.
//

import SwiftUI

@main
struct PhotoManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
