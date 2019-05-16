//
//  FriendAllFotoController.swift
//  myVK
//
//  Created by Дмитрий Яровой on 02/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit

class FriendAllFotoController: UIViewController {
    
    var friendData: FriendsModel?
    let segueIdentifier = "PhotoViewerSegue"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == segueIdentifier else { return }
        guard let indexPath = collectionView.indexPathsForSelectedItems else { return }
        
        let photoViewerController = segue.destination as! PhotoViewerController
        
        photoViewerController.startFotoIndex = indexPath[0].row
        photoViewerController.friendFoto = friendData?.fotoAlbom
    }

}

extension FriendAllFotoController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let number = friendData?.fotoAlbom?.count else { return 1}
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdetifire = "FriendAllFotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdetifire, for: indexPath) as! FriendAllFotoCell
        
        if let fotoArray = friendData?.fotoAlbom {
            let foto = fotoArray[indexPath.row]
            cell.fotoImage.image = UIImage(named: foto)
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
