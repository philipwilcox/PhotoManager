//
//  ContentView.swift
//  PhotoManager
//
//  Created by Philip Wilcox on 8/19/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @ObservedObject var libraryViewModel: LibraryViewModel

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Num photos: ")
                    TextField("NumPhotos", value: $libraryViewModel.numPhotos, formatter: NumberFormatter())
                }
                List {
                    ForEach($libraryViewModel.photoInfoList) { item in
                        // TODO: why is the size a binding?
                        let formatted = "Photo \(item.id) - \(item.humanReadableSizeOnDisk.wrappedValue)"
                        Text(formatted)
                    }
                }
            }
        }
    }
}


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            libraryViewModel: LibraryViewModel(context: PersistenceController.preview.container.viewContext, fake: true)
        ).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
