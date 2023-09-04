//
//  ContentView.swift
//  PhotoManager
//
//  Created by Philip Wilcox on 8/19/23.
//

import SwiftUI
import CoreData
import Photos
import PhotosUI

struct PhotoThumbnailView: View {
    
    @Binding var asset: PHAsset
    var imageManager: PHCachingImageManager
    
    var body: some View {
        // TODO: make thumbnail size dynamic
        let thumbnailSize = CGSize(width: 200, height: 200)
        var image: UIImage?
        var _ = imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { resultImage, _ in
            image = resultImage!
        })
        Image(uiImage: image!)
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @ObservedObject var libraryViewModel: LibraryViewModel
    
    fileprivate let imageManager = PHCachingImageManager()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Num photos: ")
                    TextField("NumPhotos", value: $libraryViewModel.numPhotos, formatter: NumberFormatter())
                }
                List {
                    // TODO: paginate these lists
                    ForEach($libraryViewModel.photoInfoList) { item in
                        // TODO: why is the size a binding?
                        let formatted = "Photo \(item.filename.wrappedValue) - \(item.humanReadableSizeOnDisk.wrappedValue)"
                        HStack {
                            Text(formatted)
                            // TODO: figure out bindings here
                            PhotoThumbnailView(asset: item.asset, imageManager: imageManager)
                        }
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
