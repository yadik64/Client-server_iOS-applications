//
//  PhotoViewerController.swift
//  myVK
//
//  Created by Дмитрий Яровой on 02/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class PhotoViewerController: UIViewController  {
    
    var friendFoto: Results<PhotoItem>!
    
    var startFotoIndex = 0
    var start = true
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.title = "hi"
        
    }
    
}

extension PhotoViewerController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let number = friendFoto.count
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "PhotoViewerCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PhotoViewerCell
        
        if start {
            
            collectionView.scrollToItem(at: IndexPath(item: startFotoIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            start = false
        }
        let urlString = friendFoto[indexPath.row].maxSizePhotoUrl
        guard let url = URL(string: urlString) else { return cell }
        cell.photoImage.kf.setImage(with: url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sizeCell = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return sizeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}
