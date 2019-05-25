//
//  PhotoViewerController.swift
//  myVK
//
//  Created by Дмитрий Яровой on 02/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit

class PhotoViewerController: UIViewController  {
    
    var friendFoto: [PhotoItem]?
    var startFotoIndex = 0
    var start = true
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension PhotoViewerController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let number = friendFoto?.count else { return 1}
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "PhotoViewerCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PhotoViewerCell
        
        if start {
            
            collectionView.scrollToItem(at: IndexPath(item: startFotoIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            start = false
        }
        let lastIndex = (friendFoto?[indexPath.row].sizes.count)! - 1
        guard let url = friendFoto?[indexPath.row].sizes[lastIndex].url else { return cell }
        cell.photoImage.downloadedFrom(link: url)
        
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
