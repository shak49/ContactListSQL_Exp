//
//  SQLDataSource.swift
//  ContactList_Exp
//
//  Created by Shak Feizi on 10/14/21.
//

import Foundation
import SQLite


class SQLDatabase {
    static let sharedInstance: SQLDatabase = SQLDatabase()
    var database: Connection?
    
    private init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("contactList").appendingPathComponent("sqlite")
            database = try Connection(fileURL.path)
        } catch {
            print("Creating connection to the database error: \(error)")
        }
    }
    
    func createTable() {
        SQLCommands.createTable()
    }
}

