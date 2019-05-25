//
//  GroupsSearchModel.swift
//  myVK
//
//  Created by Дмитрий Яровой on 25/05/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation

struct GroupsSearchModel: Decodable {
    var response: [SearchItems]
}

struct SearchItems : Decodable {
    var name: String?
    var photo100: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case photo100 = "photo_100"
    }
}

extension GroupsSearchModel {
    private enum TopCodingKeys: CodingKey {
        case response
        case items
    }
    
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: TopCodingKeys.self)
        let meta = try container.nestedContainer(keyedBy: TopCodingKeys.self, forKey: .response)
        let items = try meta.decode([SearchItems].self, forKey: .items)
        self.init(response: items)
    }
}
