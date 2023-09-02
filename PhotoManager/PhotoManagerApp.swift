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
            ContentView(
                libraryViewModel: LibraryViewModel(context: PersistenceController.preview.container.viewContext, fake: false)
                )
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
