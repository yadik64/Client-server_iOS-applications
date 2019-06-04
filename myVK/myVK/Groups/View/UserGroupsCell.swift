//
//  UserGroupsCell.swift
//  myVK
//
//  Created by Дмитрий Яровой on 14/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit

class UserGroupsCell: UITableViewCell {

    @IBOutlet weak var iconGroup: AvatarView!
    @IBOutlet weak var nameGroup: UILabel!
    
    override func prepareForReuse() {
        iconGroup.image = nil
        nameGroup.text = nil
    }
    
    public func configure(with group: GroupsItem) {
        nameGroup.text = group.name
        iconGroup.downloadedFrom(link: group.photo100)
    }
}
