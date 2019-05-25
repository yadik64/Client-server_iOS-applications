//
//  FriendsModel.swift
//  myVK
//
//  Created by Дмитрий Яровой on 23/05/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation

class FriendsModel: Codable {
    let response: FriendsResponse
}

struct FriendsResponse: Codable, Hashable {
    let items: [FriendsItem]
}

struct FriendsItem: Codable,  Hashable {
    let id: Int?
    let firstName, lastName: String?
    let isClosed, canAccessClosed: Bool?
    let nickname: String?
    let photo100: String?
    let online: Int?
}
