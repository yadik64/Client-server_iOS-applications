//
//  PhotosModelController.swift
//  myVK
//
//  Created by Дмитрий Яровой on 25/05/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation
import Alamofire

class PhotosService {
    
    let session = Session.shared
    
    func loadPhotosData(userId id: Int, completion: @escaping (PhotoResponse) -> Void) {
        
        let url = "https://api.vk.com/method/photos.getAll"
        let parameters: Parameters = [
            "owner_id": id,
            "order": "hints",
            "extended": "0",
            "count": "20",
            "photo_sizes": "1",
            "access_token": session.token,
            "v": "5.95"
        ]
        
        AF.request(url, method: .get, parameters: parameters).validate().responseData { (response) in
            guard let data = response.value else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(PhotoModel.self, from: data).response
                completion(result)
                print(result.items)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
