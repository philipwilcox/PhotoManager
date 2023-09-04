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
//    @Published var photoInfoMap: [String: PhotoInfo]
    @Published var photoInfoList: [PhotoInfo]
    
    
    init(context: NSManagedObjectContext, fake: Bool) {
        numPhotos = 0
//        photoInfoMap = [:]
        photoInfoList = []
        super.init()
        // TODO: make a better way to get fake data from persistence layer...
        if (!fake) {
            PHPhotoLibrary.shared().register(self)
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let photoFetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
            //        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
            //        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            let _ = photoFetchResult.firstObject
            // TODO: so this is just lazy and allPhotos.count will be 0 until I look for one?
            numPhotos = photoFetchResult.count
            var numFaves = 0
            // TODO: this takes forever, make it async and show a spinner!
            photoFetchResult.enumerateObjects({ asset, i, stop in
                // TODO: compute file size for each here, then store this list in sorted order and use that in the UI
                if (asset.isFavorite) {
                    numFaves += 1
                }
                let resources = PHAssetResource.assetResources(for: asset) // your PHAsset

                var sizeOnDisk: Int64? = 0

                if let resource = resources.first {
                  let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                  sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
                }
                // TODO: what to do if this blows up if i see assets without sizes?
//                self.self.photoInfoMap[asset.localIdentifier] = PhotoInfo(
                self.photoInfoList.append(PhotoInfo(
                    id: asset.localIdentifier,
                    asset: asset,
                    bytesOnDisk: sizeOnDisk!,
                    humanReadableSizeOnDisk: self.convertByteToHumanReadable(sizeOnDisk!),
                    filename: resources[0].originalFilename
              ))
            })
            photoInfoList.sort(by: {(a: PhotoInfo, b: PhotoInfo) -> Bool in
                return a.bytesOnDisk > b.bytesOnDisk
            })
            // TODO: and also show thumbnails
        }
        else {
            numPhotos = 5
        }
    }
    
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // TODO: handle changes here
    }
    
    
    private func convertByteToHumanReadable(_ bytes:Int64) -> String {
        // https://stackoverflow.com/questions/45110720/get-file-size-of-phasset-without-loading-in-the-resource
         let formatter:ByteCountFormatter = ByteCountFormatter()
         formatter.countStyle = .binary

         return formatter.string(fromByteCount: Int64(bytes))
     }
    
    
}
