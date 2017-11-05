//
//  SQLiteDatabase.swift
//  SQLiteSwiftApp
//
//  Created by Ivica Tokic on 26/10/2017.
//  Copyright © 2017 Ivica Tokic. All rights reserved.
//

import Foundation
import SQLite3

enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}

class SQLiteDatabase{
    
    fileprivate let dbPointer: OpaquePointer?
    
    fileprivate init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    
    deinit {
        sqlite3_close(dbPointer)
    }
    
    static func openDatabase(path: String) throws -> SQLiteDatabase {
        var db: OpaquePointer? = nil
        
        if sqlite3_open(path, &db) == SQLITE_OK {
            return SQLiteDatabase(dbPointer: db)
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String.init(cString: errorPointer)
                throw SQLiteError.OpenDatabase(message: message)
            } else {
                throw SQLiteError.OpenDatabase(message: "No error message provided from sqlite.")
            }
        }
    }
    
    var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }
    
    func createTable(table: SQLTable.Type) throws {
        let createTableStatement = try prepareStatement(sql: table.createStatement)
        defer {
            sqlite3_finalize(createTableStatement)
        }
        guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
    }
    
    func insert(museum: Museum) throws {
        let insertSql = "INSERT INTO Museums (Id, Name,Address) VALUES (?, ?, ?);"
        
        let insertStatement = try prepareStatement(sql: insertSql)
        defer {
            sqlite3_finalize(insertStatement)
        }
        
        let id: Int32 = museum.id
        let name = museum.name as NSString
        let address = museum.address as NSString
        
        guard sqlite3_bind_int(insertStatement, 1, id) == SQLITE_OK  &&
            sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 3, address.utf8String, -1, nil) == SQLITE_OK
            else {
                throw SQLiteError.Bind(message: errorMessage)
        }
        
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        
        print("Row inserted")
    }
    
    func updateMuseum(museum: Museum) throws {
        let insertSql = "UPDATE Museums Set Name = ?,Address = ? Where Id = ?;"
        
        let insertStatement = try prepareStatement(sql: insertSql)
        defer {
            sqlite3_finalize(insertStatement)
        }
        
        let name = museum.name as NSString
        let address = museum.address as NSString
        let id = museum.id
        
        guard sqlite3_bind_text(insertStatement, 1, name.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 2, address.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_int(insertStatement, 3, id) == SQLITE_OK
            else {
                throw SQLiteError.Bind(message: errorMessage)
        }
        
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        
    }
    
    func getMuseumsArray() -> [Museum]? {
        let querySql = "SELECT * FROM Museums;"
        
        var museumsArray = [Museum]()
        
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return nil
        }
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        while(sqlite3_step(queryStatement) == SQLITE_ROW) {
            let id = sqlite3_column_int(queryStatement, 0)
            let name = sqlite3_column_text(queryStatement, 1)
            let address = sqlite3_column_text(queryStatement, 2)
            
            let museusm = Museum(id: id, name: String(cString: name!), address: String(cString: address!))
            
            museumsArray.append(museusm)
        }
        return museumsArray
    }
}

extension SQLiteDatabase {
    
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer? = nil
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.Prepare(message: errorMessage)
        }
        
        return statement
    }
    
}
