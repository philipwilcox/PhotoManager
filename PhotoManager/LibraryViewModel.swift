//
//  LibraryViewModel.swift
//  PhotoManager
//
//  Created by Philip Wilcox on 8/19/23.
//

import Foundation
import CoreData
import Photos


class LibraryViewModel: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
    
    // TODO: add persistance around what version of the photos library we've seen and what photos we've seen instead of
    //       reloading all each time? but then we'll need to manage potentially a lot of changes on reload... so maybe just
    //       persist stuff like photo -> filesize in a map that we can reference and prune periodically
    @Published var numPhotos: Int
    
    
    init(context: NSManagedObjectContext, fake: Bool) {
        numPhotos = 0
        super.init()
        // TODO: make a better way to get fake data from persistence layer...
        if (!fake) {
            PHPhotoLibrary.shared().register(self)
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
            //        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
            //        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            numPhotos = allPhotos.count
        }
        else {
            numPhotos = 5
        }
    }
    
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // TODO: handle changes here
    }
    
    
}
