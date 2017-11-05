//
//  DatabaseManager.swift
//  SQLiteSwiftApp
//
//  Created by Ivica Tokic on 31/10/2017.
//  Copyright © 2017 Ivica Tokic. All rights reserved.
//

import Foundation

//Singleton class that provides methods for inserting and updating database

public final class DatabaseManager {
    
    internal let filePath: String
    
    public static let shared: DatabaseManager = {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(Constants.databaseName)
        let fileURLPath = fileURL.path
        return DatabaseManager(filePath: fileURLPath)
    }()
    
    private init(filePath: String){
        self.filePath = filePath
    }
    
    public func createDatabase() {
        do {
            let db = try SQLiteDatabase.openDatabase(path: filePath)
            print(filePath)
            try db.createTable(table: Museum.self)
        }
        catch SQLiteError.OpenDatabase(let message) {
            print(message)
        }
        catch {
        }
    }
    public func getMuseumsFromDatabase() -> [Museum]{
        var museumsArray = [Museum]()
        do {
            let db = try SQLiteDatabase.openDatabase(path: filePath)
            museumsArray = db.getMuseumsArray()!
        }  catch SQLiteError.OpenDatabase(let message) {
            print(message)
        }
        catch {
            
        }
        return museumsArray
    }
    
    public func insert(_ museum: Museum) {
        do {
            let db = try SQLiteDatabase.openDatabase(path: filePath)
            try db.insert(museum: museum)
            
        }  catch SQLiteError.OpenDatabase(let message) {
            print(message)
        }
        catch {
            
        }
    }
    
    public func update(_ museum: Museum) {
        do {
            let db = try SQLiteDatabase.openDatabase(path: filePath)
            try db.updateMuseum(museum: museum)
        }  catch SQLiteError.OpenDatabase(let message) {
            print(message)
        }
        catch {
            
        }
        
    }
    
    
}
