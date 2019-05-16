//
//  ZoomInOutCollectionViewLayout.swift
//  myVK
//
//  Created by Дмитрий Яровой on 02/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit

class ZoomInOutCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?.compactMap {$0.copy() as? UICollectionViewLayoutAttributes}.compactMap(addZoomInOutToAttributes)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private func addZoomInOutToAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        
        let width = collectionView.frame.width
        let centerX = width / 2
        let offset = collectionView.contentOffset.x
        let itemX = attributes.center.x - offset
        let position = (itemX - centerX) / width
        
        if position <= 0 && position > -1 {
            let scaleFactor = 0.5 * position + 1.0
            attributes.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        } else {
            attributes.transform = .identity
        }
        
        return attributes
    }
}
