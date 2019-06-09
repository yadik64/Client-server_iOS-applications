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
    let dbManager = DBManager.shared
    var notificationToken: NotificationToken?
    lazy var photoData: Results<PhotoItem> = { self.dbManager.getDataFromDb().filter("ownerId = %@", self.userId) }()
    var userId: Int = 0
    var friendData: FriendsModel?
    let segueIdentifier = "PhotoViewerSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = photoData._observe({ [weak self] (changes) in
            guard let self = self else { return }
            
            switch changes {
            case .initial(_):
                self.collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.collectionView.performBatchUpdates({
                    self.collectionView.deleteItems(at: deletions.map {IndexPath(row: $0, section: 0)})
                    self.collectionView.insertItems(at: insertions.map {IndexPath(row: $0, section: 0)})
                    self.collectionView.reloadItems(at: modifications.map {IndexPath(row: $0, section: 0)})
                }, completion: nil)
            case .error(let error):
                print(error)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        NetworkService.loadingData(for: .friendPhotos, userId: String(describing: userId)) { [weak self] (response: Result<PhotoModel, Error>) in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                do {
                    try self.dbManager.addData(result.response.items)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == segueIdentifier else { return }
        guard let indexPath = collectionView.indexPathsForSelectedItems else { return }
        
        let photoViewerController = segue.destination as! PhotoViewerController
        
        photoViewerController.startFotoIndex = indexPath[0].row
        photoViewerController.friendFoto = photoData.filter("ownerId = %@", self.userId)
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
