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
                table.column(firstName)
                table.column(lastName)
                table.column(phoneNumber)
            }))
        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    static func update(contact: Contact) -> Bool? {
        guard let database = SQLDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        let tableItem = table.filter(id == contact.id).limit(1)
        do {
            if try database.run(tableItem.update(firstName <- contact.firstName, lastName <- contact.lastName, phoneNumber <- contact.phoneNumber)) > 0 {
                print("Contact is updated")
                return true
            } else {
                print("Could not update contact: contact is not found")
                return false
            }
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Update row faild: \(message) in \(String(describing: statement))")
            return false
        } catch let error {
            print("Update faild: \(error)")
            return false
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
    
    static func delete(contactID: Int) {
        guard let database = SQLDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        do {
            let tableItem = table.filter(id == contactID).limit(1)
            try database.run(tableItem.delete())
        } catch {
            print("Delete error: \(error)")
        }
    }
}








