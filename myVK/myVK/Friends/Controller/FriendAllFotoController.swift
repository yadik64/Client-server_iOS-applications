//
//  FriendAllFotoController.swift
//  myVK
//
//  Created by Дмитрий Яровой on 02/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit

class FriendAllFotoController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userId: Int?
    var photoData = [PhotoItem]()
    var friendData: FriendsModel?
    let segueIdentifier = "PhotoViewerSegue"
    let photosService = PhotosService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = userId else { return }
        print(id)
        photosService.loadPhotosData(userId: id) { (responseArray) in
            self.photoData = responseArray.items
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == segueIdentifier else { return }
        guard let indexPath = collectionView.indexPathsForSelectedItems else { return }
        
        let photoViewerController = segue.destination as! PhotoViewerController
        
        photoViewerController.startFotoIndex = indexPath[0].row
        photoViewerController.friendFoto = photoData
    }
    
}

extension FriendAllFotoController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdetifire = "FriendAllFotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdetifire, for: indexPath) as! FriendAllFotoCell
        let photoArray = photoData[indexPath.row].sizes
        if !photoArray.isEmpty {
            let url = photoArray[0].url
            cell.fotoImage.downloadedFrom(link: url)
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
