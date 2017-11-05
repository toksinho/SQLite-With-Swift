//
//  SQLTableProtocol.swift
//  SQLiteSwiftApp
//
//  Created by Ivica Tokic on 26/10/2017.
//  Copyright © 2017 Ivica Tokic. All rights reserved.
//

import Foundation

//protocol that class must implement for creating new table
protocol SQLTable {
    static var createStatement: String { get }
}
