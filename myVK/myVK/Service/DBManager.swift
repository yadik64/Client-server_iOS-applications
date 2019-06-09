//
//  DBManager.swift
//  myVK
//
//  Created by Дмитрий Яровой on 06/06/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    private let database: Realm
    public static var shared = DBManager()
    
    private init() {
        let configRealm = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        self.database = try! Realm(configuration: configRealm)
        print(self.database.configuration.fileURL!)
    }
    
    public func getDataFromDb<T: Object>() -> Results<T> {
        let results = { self.database.objects(T.self) }()
        return results
    }
    
    public func addData<T: Object>(_ object: [T]) throws {
        try database.write {
            database.add(object, update: .modified)
        }
    }
    
    public func deleteAllFromDb() throws {
        try database.write {
            database.deleteAll()
        }
    }
    
    public func deleteFromDb<T: Object>(_ object: T) throws {
        try database.write {
            database.delete(object)
        }
    }
}
