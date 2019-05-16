//
//  CustomSegueLogin.swift
//  myVK
//
//  Created by Дмитрий Яровой on 02/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit

class CustomSegueLogin: UIStoryboardSegue {
    
    var leftView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5215686275, blue: 0.6980392157, alpha: 1)
        return view
    }()
    
    var rightView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5215686275, blue: 0.6980392157, alpha: 1)
        return view
    }()

    override func perform() {
        
        guard let containerView = source.view.superview else { return }

        containerView.addSubview(destination.view)

        let leftViewTargetFrame = CGRect(x: -containerView.frame.width, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        let rightViewTargetFrame = CGRect(x: containerView.frame.width, y: 0, width: containerView.frame.width, height: containerView.frame.height)

        destination.view.frame = CGRect(x: 0,
                                        y: 0,
                                        width: containerView.frame.width,
                                        height: containerView.frame.height)

        destination.view.addSubview(leftView)
        leftView.frame = CGRect(x: 0,
                                y: 0,
                                width: containerView.frame.width,
                                height: containerView.frame.height)

        destination.view.addSubview(rightView)
        rightView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: containerView.frame.width,
                                 height: containerView.frame.height)

        UIView.animate(withDuration: 0.5, animations: {
            self.leftView.frame = leftViewTargetFrame
            self.rightView.frame = rightViewTargetFrame
        }) { (finished) in
            self.source.present(self.destination, animated: false, completion: nil)
        }

    }

}
