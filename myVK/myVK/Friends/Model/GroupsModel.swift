//
//  GroupsModel.swift
//  myVK
//
//  Created by Дмитрий Яровой on 25/05/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation

struct GroupsModel: Codable {
    let response: GroupsResponse
}

struct GroupsResponse: Codable {
    var items: [GroupsItem]
}

struct GroupsItem: Codable {
    let id: Int
    let name: String?
    let screenName: String?
    let isClosed, isAdmin, isMember, isAdvertiser: Int?
    let type: String?
    let photo50, photo100, photo200: String
    
}

