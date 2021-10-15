//
//  SQLCommands.swift
//  ContactList_Exp
//
//  Created by Shak Feizi on 10/14/21.
//

import Foundation
import SQLite
import SQLite3


class SQLCommands {
    // Shak notes: Properties
    static var table = Table("contact")
    static let id = Expression<Int>("id")
    static let firstName = Expression<String>("firstName")
    static let lastName = Expression<String>("lastName")
    static let phoneNumber = Expression<String>("phoneNumber")
    
    // Shak notes: Functions
    static func createTable() {
        guard let database = SQLDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        do {
            try database.run(table.create(ifNotExists: true, block: { table in
                table.column(id, primaryKey: true)
                table.column(firstName, primaryKey: true)
                table.column(lastName, primaryKey: true)
                table.column(phoneNumber, primaryKey: true)
            }))
        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    static func insertRow(contact: Contact) -> Bool? {
        guard let database = SQLDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        do {
            try database.run(table.insert(firstName <- contact.firstName, lastName <- contact.lastName, phoneNumber <- contact.phoneNumber))
            return true
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Insert row faild: \(message) in \(String(describing: statement))")
            return false
        } catch let error {
            print("Insertion faild: \(error)")
            return false
        }
    }
    
    static func read() -> [Contact]? {
        guard let database = SQLDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        var contacts: [Contact] = []
        table = table.order(id.desc)
        do {
            for contact in try database.prepare(table) {
                let id = contact[id]
                let firstName = contact[firstName]
                let lastName = contact[lastName]
                let phoneNumber = contact[phoneNumber]
                let contactObject = Contact(id: id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
                contacts.append(contactObject)
                print("\(contacts)")
            }
        } catch {
            print("Read rows error: \(error)")
        }
        return contacts
    }
}








