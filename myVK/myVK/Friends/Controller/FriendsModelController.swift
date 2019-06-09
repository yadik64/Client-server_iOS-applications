//
//  FriendsModelController.swift
//  myVK
//
//  Created by Дмитрий Яровой on 23/05/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation
import RealmSwift

class FriendsModelController {
    
    let dbManager = DBManager.shared
    lazy var allFriendsArray: Results<FriendsItem> = { self.dbManager.getDataFromDb() }()
    var importantFriedsArray = [FriendsItem]()
    var friendsAllButImportant = [FriendsItem]()
    var friendsDictionary = [String: [FriendsItem]]()
    var sectionName = [String]()
    
    
    init() {
        NetworkService.loadingData(for: .friends) { (response: Result<FriendsModel, Error>) in
            switch response {
            case .success(let result):
                do {
                    try self.dbManager.addData(result.response.items)
                } catch {
                    print(error)
                }
                self.importantFriedsArray = {
                    var returnArray = [FriendsItem]()
                    for index in 0...5 {
                        returnArray.append(self.allFriendsArray[index])
                    }
                    return returnArray
                }()
                self.friendsAllButImportant = self.allFriendsArray.filter{!self.importantFriedsArray.contains($0)}.sorted{
                    return $0.lastName < $1.lastName
                }
                
                self.sortFriendsAlphabetically()
                self.sendNotifications()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func sortFriendsAlphabetically() {
        
        for element in friendsAllButImportant {
            guard let key = element.lastName.first else { continue }
            if friendsDictionary[String(key)] == nil {
                friendsDictionary[String(key)] = [element]
            } else {
                friendsDictionary[String(key)]?.append(element)
            }
        }
        sectionName = Array(friendsDictionary.keys).sorted()
    }
    
    private func sendNotifications() {
        let friendsDataReceivedNotifications = Notification.Name("friendsDataReceived")
        NotificationCenter.default.post(name: friendsDataReceivedNotifications, object: nil)
    }
    
}
