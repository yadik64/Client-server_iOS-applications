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

class GroupsModel: Codable {
    let response: GroupsResponse
}

class GroupsResponse: Codable {
    var items: [GroupsItem]
}

@objcMembers class GroupsItem: Object, Codable {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var screenName  = ""
    dynamic var type = ""
    dynamic var photo100 = ""
    
}

