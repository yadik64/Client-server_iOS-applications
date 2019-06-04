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
    //
    public static func loadingData<T: Decodable>(for requestPath: URLRequestPath, userId: String = session.id, completion: @escaping(Swift.Result<T, Error>) -> Void) {
        let parameters = makeParameters(from: requestPath, userId: userId)
        guard let url = URL(string: baseURL + requestPath.rawValue) else { return }
        AF.request(url, method: .get, parameters: parameters).validate().responseData { (response) in
            guard let data = response.value else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public static func groupSearch(by text: String, complition: @escaping(Swift.Result<GroupsModel, Error>) -> Void) {
        guard text != "" else { return }
        let path = "/method/groups.search"
        let parameters: Parameters = [
            "q": text,
            "count": "20",
            "access_token": session.token,
            "v": "5.95"
        ]
        
        AF.request(baseURL + path , method: .get, parameters: parameters).validate().response { (response) in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let result = try decoder.decode(GroupsModel.self, from: data)
                    complition(.success(result))
                } catch {
                    complition(.failure(error))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
