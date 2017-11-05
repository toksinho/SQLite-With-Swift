//
//  Museum.swift
//  SQLiteSwiftApp
//
//  Created by Ivica Tokic on 26/10/2017.
//  Copyright © 2017 Ivica Tokic. All rights reserved.
//

import Foundation

public class Museum: NSObject {
    
    var name: String
    var address: String
    var id: Int32
    
    init(id: Int32, name: String, address: String) {
        self.name = name
        self.address = address
        self.id = id
    }
}

extension Museum: SQLTable {
    static var createStatement: String {
        return """
        CREATE TABLE Museums(
        Id INT PRIMARY KEY NOT NULL,
        Name CHAR(255),
        Address CHAR(255)
        );
        """
    }
}
