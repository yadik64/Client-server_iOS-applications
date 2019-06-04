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
    dynamic var name = ""
    dynamic var photo100 = ""
    
    convenience init(name: String, photo100: String) {
        self.init()
        self.name = name
        self.photo100 = photo100
    }
    
}