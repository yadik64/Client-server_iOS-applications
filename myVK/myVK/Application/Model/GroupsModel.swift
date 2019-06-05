//
//  GroupsModel.swift
//  myVK
//
//  Created by Дмитрий Яровой on 25/05/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class GroupsModel: Decodable {
    let response: GroupsResponse
}

class GroupsResponse: Decodable {
    var items: [GroupsItem]
}

@objcMembers class GroupsItem: Object, Decodable {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var photo100 = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, name: String, photo100: String) {
        self.init()
        self.id = id
        self.name = name
        self.photo100 = photo100
    }
    
}
