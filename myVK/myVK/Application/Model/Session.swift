//
//  Session.swift
//  myVK
//
//  Created by Дмитрий Яровой on 18/05/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation

class Session {
    
    var token: String = ""
    var id: String = ""
    
    public static var shared = Session()
    
    private init(){}
    
}
