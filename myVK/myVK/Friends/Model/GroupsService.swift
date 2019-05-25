//
//  GroupService.swift
//  myVK
//
//  Created by Дмитрий Яровой on 25/05/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation
import Alamofire

class GroupsService {
    
    
    
    public static func loadingGroupData(completion: @escaping ([GroupsItem]) -> Void) {
        
        let session = Session.shared
        let url = "https://api.vk.com/method/groups.get"
        let parameters: Parameters = [
            "user_id": session.id,
            "extended": "1",
            "access_token": session.token,
            "v": "5.95"
        ]
        
        AF.request(url, method: .get, parameters: parameters).validate().responseData { (responce) in
            guard let data = responce.value else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let groups = try decoder.decode(GroupsModel.self, from: data).response.items
                completion(groups)
            } catch {
                print(error)
            }
        }
    }
    
    
}
