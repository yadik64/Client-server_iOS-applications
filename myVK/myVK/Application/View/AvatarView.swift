//
//  AvatarView.swift
//  myVK
//
//  Created by Дмитрий Яровой on 03/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit

class AvatarView: UIView {
    
    var image: UIImage? {
        willSet {
            imageView.image = newValue
        }
    }
    private var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView = UIImageView(frame: bounds)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        imageView.layer.borderWidth = 1.0
        addSubview(imageView)
        
        layer.cornerRadius = imageView.frame.width / 2
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowOpacity = 0.6
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    }
}
