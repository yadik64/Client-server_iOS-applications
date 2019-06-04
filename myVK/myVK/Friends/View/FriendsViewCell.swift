//
//  FriendsViewCell.swift
//  myVK
//
//  Created by Дмитрий Яровой on 02/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit

class FriendsViewCell: UITableViewCell {

    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var nameFriendLabel: UILabel!
    
    override func prepareForReuse() {
        avatarView.image = nil
        nameFriendLabel.text = nil
    }
    
    public func configure(with friend: FriendsItem) {
        nameFriendLabel.text = friend.firstName + " " + friend.lastName
        avatarView.downloadedFrom(link: friend.photo100)
        
    }
    
}
