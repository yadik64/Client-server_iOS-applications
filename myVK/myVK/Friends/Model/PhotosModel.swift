//
//  PhotosModel.swift
//  myVK
//
//  Created by Дмитрий Яровой on 25/05/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class PhotoModel: Decodable {
    let response: PhotoResponse
}

class PhotoResponse: Decodable {
    let items: [PhotoItem]
}

@objcMembers class PhotoItem: Object, Decodable {
    dynamic var id: Int = 0
    dynamic var  maxSizePhotoUrl: String = ""
    dynamic var  smallSizePhotoUrl: String = ""
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case sizes
    }
    
    enum SizesKeys: CodingKey {
        case url
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        var array = try container.nestedUnkeyedContainer(forKey: .sizes)
        let sizesContainer = try array.nestedContainer(keyedBy: SizesKeys.self)
        self.smallSizePhotoUrl = try sizesContainer.decode(String.self, forKey: .url)
        while !array.isAtEnd {
            let sizesContainer = try array.nestedContainer(keyedBy: SizesKeys.self)
            self.maxSizePhotoUrl = try sizesContainer.decode(String.self, forKey: .url)
        }
    }
    
    convenience init(id: Int, maxPhoto: String, minPhoto: String) {
        self.init()
        self.id = id
        self.maxSizePhotoUrl = maxPhoto
        self.smallSizePhotoUrl = minPhoto
    }
}
