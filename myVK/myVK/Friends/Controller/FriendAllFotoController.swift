//
//  FriendAllFotoController.swift
//  myVK
//
//  Created by Дмитрий Яровой on 02/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class FriendAllFotoController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userId: Int?
    let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    lazy var realm = try! Realm(configuration: realmConfig)
    lazy var photoData: Results<PhotoItem> = { self.realm.objects(PhotoItem.self).filter("ownerId = %@", self.userId!) }()
    var friendData: FriendsModel?
    let segueIdentifier = "PhotoViewerSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = userId else { return }

        NetworkService.loadingData(for: .friendPhotos, userId: String(describing: id)) { [weak self] (response: Result<PhotoModel, Error>) in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                do {
                    let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
                    let realm = try Realm(configuration: config)
                    try realm.write {
                        realm.add(result.response.items, update: true)
                    }
                } catch {
                    print(error)
                }
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == segueIdentifier else { return }
        guard let indexPath = collectionView.indexPathsForSelectedItems else { return }
        
        let photoViewerController = segue.destination as! PhotoViewerController
        
        photoViewerController.startFotoIndex = indexPath[0].row
        photoViewerController.friendFoto = photoData.filter("ownerId = %@", self.userId!)
    }
    
}

extension FriendAllFotoController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdetifire = "FriendAllFotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdetifire, for: indexPath) as! FriendAllFotoCell
        let urlString = photoData[indexPath.row].smallSizePhotoUrl
        if urlString != "" {
            guard let url = URL(string: urlString) else { return cell }
            cell.fotoImage.kf.setImage(with: url)
        } else {
            cell.fotoImage.image = UIImage(named: "nophoto")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.width / 3)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
}
