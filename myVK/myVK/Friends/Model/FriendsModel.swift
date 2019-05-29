//
//  FriendsModel.swift
//  myVK
//
//  Created by Дмитрий Яровой on 23/05/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class FriendsModel: Codable {
    let response: FriendsResponse
}

class FriendsResponse: Codable {
    let items: [FriendsItem]
}

@objcMembers class FriendsItem: Object, Codable {
    
    dynamic var id = 0
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var photo100: String? = nil
    dynamic var online: Int? = nil
    
    convenience init(id: Int, firsName: String, lastName: String, photo100: String?, online: Int ) {
        self.init()
        self.id = id
        self.firstName = firsName
        self.lastName = lastName
        self.photo100 = photo100
        self.online = online
    }
}
