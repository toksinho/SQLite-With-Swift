//
//  UserDefaults.swift
//  SQLiteSwiftApp
//
//  Created by Ivica Tokic on 31/10/2017.
//  Copyright © 2017 Ivica Tokic. All rights reserved.
//

import Foundation

//this class will manage state of the database
//if database is empty then fill it with ZagrebMuseums.plist data
class DatabaseState {
    
    static let instance  = DatabaseState()
    private init() {}
    
    func setDatabaseState(databaseState: Bool) {
        UserDefaults.standard.set(databaseState, forKey: "DatabaseState")
    }
    
    func getDatabaseState() -> Bool {
        return UserDefaults.standard.bool(forKey: "DatabaseState")
    }
}
