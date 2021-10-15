//
//  ContactListVM.swift
//  ContactList_Exp
//
//  Created by Shak Feizi on 10/14/21.
//

import Foundation


class ContactListVM {
    // Shak notes: Properties
    private var contacts: [Contact] = []
    
    // Shak notes: Functions
    func connectToDatabase() {
        let database = SQLDatabase.sharedInstance
    }
    
    func loadDataFromDatabase() {
        contacts = SQLCommands.read() ?? []
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if contacts.count != 0 {
            return contacts.count
        }
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Contact {
        return contacts[indexPath.row]
    }
}
