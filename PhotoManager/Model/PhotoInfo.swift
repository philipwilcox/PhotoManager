//
//  PhotoInfo.swift
//  PhotoManager
//
//  Created by Philip Wilcox on 9/2/23.
//

import Foundation
import Photos

struct PhotoInfo : Identifiable {
    public let id: String
    public var asset: PHAsset
    
    // TODO: should this implement Decodable?
//    public let localIdentifier: String
    public let bytesOnDisk: Int64
    // TODO: why does this have to be a var for "let formatted = "Photo \(item.id) - \(item.humanReadableSizeOnDisk)" to work?
    public var humanReadableSizeOnDisk: String
    public var filename: String
}
