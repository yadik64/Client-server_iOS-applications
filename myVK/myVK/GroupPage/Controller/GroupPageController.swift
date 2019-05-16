//
//  GroupPageController.swift
//  myVK
//
//  Created by Дмитрий Яровой on 14/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit

protocol GroupPageControllerDelegate: AnyObject {
    func deleteGroup(group: Group)
    func addGroup(group: Group)
}

class GroupPageController: UIViewController {

    @IBOutlet weak var iconGroup: AvatarView!
    @IBOutlet weak var nameGroup: UILabel!
    @IBOutlet weak var joinedButton: UIButton!
    
    weak var delegate: GroupPageControllerDelegate?
    var group: Group? {
        willSet {
            if Group.userGroupsArray.contains(newValue!) {
                isJoined = true
            } else {
                isJoined = false
            }
        }
    }
    var buttonTitle: String?
    var isJoined = true {
        willSet {
            if newValue {
                buttonTitle = "Выйти из группы"
            } else {
                buttonTitle = "Присоединиться к группе"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPage()
        setTitleJoinedButton()
    }
    
    @IBAction func pressJoinedButton(_ sender: UIButton) {
        
        if isJoined {
            delegate?.deleteGroup(group: group!)
        } else {
            delegate?.addGroup(group: group!)
        }
        isJoined = !isJoined
        setTitleJoinedButton()
    }
    
    private func createPage() {
        guard let icon = group?.nameIcon,
              let name = group?.nameGroup else { return }
        
        self.iconGroup.image = UIImage(named: icon)
        self.nameGroup.text = name

    }
    
    private func setTitleJoinedButton() {
        joinedButton.setTitle(buttonTitle!, for: .normal)
    }
}
