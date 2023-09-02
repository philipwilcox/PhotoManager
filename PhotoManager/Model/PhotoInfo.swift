//
//  PhotoInfo.swift
//  PhotoManager
//
//  Created by Philip Wilcox on 9/2/23.
//

import Foundation

struct PhotoInfo : Identifiable {
    public let id: String
    
    // TODO: should this implement Decodable?
//    public let localIdentifier: String
    public let bytesOnDisk: Int64
    // TODO: why does this have to be a var for "let formatted = "Photo \(item.id) - \(item.humanReadableSizeOnDisk)" to work?
    public var humanReadableSizeOnDisk: String
}
