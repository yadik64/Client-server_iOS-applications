//
//  CharControl.swift
//  myVK
//
//  Created by Дмитрий Яровой on 10/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit

class CharControl: UIControl {

    var selectedChar: String? {
        didSet {
            updateSelectChar()
            sendActions(for: .valueChanged)
        }
    }
    var stackView: UIStackView!
    var buttonArray = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupStackView()
    }
    
    private func setupStackView() {
        
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0)
        
        for char in FriendsModel.sectionName {
            let button = UIButton(type: .system)
            button.setTitle(char.lowercased(), for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.2980392157, green: 0.4588235294, blue: 0.6392156863, alpha: 1), for: .normal)
            button.addTarget(self, action: #selector(selectChar(_:)), for: .touchUpInside)
            buttonArray.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: buttonArray)
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        self.addSubview(stackView)
    }
    
    @objc func selectChar(_ sender: UIButton) {
        guard let char = sender.titleLabel?.text else { return }
        selectedChar = char
    }
    
    private func updateSelectChar() {
        for (index, button) in buttonArray.enumerated() {
            let char = FriendsModel.sectionName[index].lowercased()
            button.isSelected = char == selectedChar
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.frame = self.bounds
    }

}
