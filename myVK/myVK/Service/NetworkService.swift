//
//  NetworkService.swift
//  myVK
//
//  Created by Дмитрий Яровой on 20/05/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation
import Alamofire

enum URLRequestPath: String {
    
    case friends = "/method/friends.get"
    case groups = "/method/groups.get"
    case friendPhotos = "/method/photos.getAll"
    
}

class NetworkService {
    
    fileprivate static let baseURL = "https://api.vk.com"
    fileprivate static let session = Session.shared
    
    fileprivate static func makeParameters(from requestPath: URLRequestPath, userId: String = session.id) -> Parameters {
        
        var parameters: Parameters = [:]
        
        switch requestPath {
        case .friends:
            parameters = [
                "owner_id": userId,
                "order": "hints",
                "fields": "nickname, photo_100",
                "name_case": "nom",
                //            "need_hidden": "0",
                //            "skip_hidden": "1",
                "access_token": session.token,
                "v": "5.95"
            ]
        case .groups:
            parameters = [
                "user_id": userId,
                "extended": "1",
                "access_token": session.token,
                "v": "5.95"
            ]
        case .friendPhotos:
            parameters = [
                "owner_id": userId,
                "order": "hints",
                "extended": "0",
                "count": "20",
                "photo_sizes": "1",
                "access_token": session.token,
                "v": "5.95"
            ]
        }
        return parameters
    }
    
    public static func loadingData(for requestPath: URLRequestPath, userId: String = session.id) {
        let parameters = makeParameters(from: requestPath, userId: userId)
        guard let url = URL(string: baseURL + requestPath.rawValue) else { return }
        AF.request(url, method: .get, parameters: parameters).validate().responseJSON { (response) in
            guard let json = response.value else { return }
            print(json)
        }
        
    }
    
    public static func groupSearch(by text: String) {
        let path = "/method/groups.search"
        let parameters: Parameters = [
            "q": text,
            "count": "20",
            "access_token": session.token,
            "v": "5.95"
        ]
        
        AF.request(baseURL + path , method: .get, parameters: parameters).validate().responseJSON { (response) in
            guard let json = response.value else { return }
            print(json)
        }
    }
    
    
}
