//
//  PhotosModel.swift
//  myVK
//
//  Created by Дмитрий Яровой on 25/05/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation

struct PhotoModel: Codable {
    let response: PhotoResponse
}

struct PhotoResponse: Codable {
    let count: Int
    let items: [PhotoItem]
}

struct PhotoItem: Codable {
    let id, albumId, ownerId: Int
    let sizes: [PhotoSize]
    let text: String
    let date: Int
    let lat, long: Double?
    let postId: Int?
}

struct PhotoSize: Codable {
    let type: TypeEnum
    let url: String
    let width, height: Int
}

enum TypeEnum: String, Codable {
    case m = "m"
    case o = "o"
    case p = "p"
    case q = "q"
    case r = "r"
    case s = "s"
    case w = "w"
    case x = "x"
    case y = "y"
    case z = "z"
}

