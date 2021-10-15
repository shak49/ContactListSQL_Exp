//
//  NewContactsVM.swift
//  ContactList_Exp
//
//  Created by Shak Feizi on 10/14/21.
//

import UIKit
import SQLite


class NewContactVM {
    // Shak notes: Properties
    var contact: Contact?
    
    let id: Int?
    let firstName: String?
    let lastName: String?
    let phoneNumber: String?
    
    init(contact: Contact?) {
        self.contact = contact
        self.id = contact?.id
        self.firstName = contact?.firstName
        self.lastName = contact?.lastName
        self.phoneNumber = contact?.phoneNumber
    }
}





