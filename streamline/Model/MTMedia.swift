//
//  MTMedia.swift
//  streamline
//
//  Created by Tayyab Ali on 17/05/2022.
//

import Foundation

public struct MTMedia: Identifiable {
    public var id: String = UUID().uuidString
    var imageURL: String
    var mediaType: MTMediaType
    var thumbnail: String
    
    static let empty = MTMedia(imageURL: "", mediaType: .empty, thumbnail: "")
}
