//
//  ViewController.swift
//  ContactList_Exp
//
//  Created by Shak Feizi on 10/14/21.
//

import UIKit

class NewContactViewController: UIViewController {
    // Shak notes: Properties
    var viewModel: NewContactVM?
    
    // Shak notes: Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        firstNameTextField.becomeFirstResponder()
        phoneNumberTextField.delegate = self
    }
    
    // Shak notes: Actions
    @IBAction func saveButton(_ sender: Any) {
        let id: Int = 0
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        let contactObject = Contact(id: id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        addContactToTable(contact: contactObject)
    }
    
    @IBAction func cancellButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Shak notes: Functions
    private func createTable() {
        let create = SQLDatabase.sharedInstance.createTable()
    }
    
    private func addContactToTable(contact: Contact) {
        let insert = SQLCommands.insertRow(contact: contact)
        if insert == true {
            dismiss(animated: true, completion: nil)
        } else {
            showError("Error", "This contact cannot be created because its phone number already exist in the contact list")
        }
    }

}


extension NewContactViewController: UITextFieldDelegate {
    private func format(mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for char in mask where index < numbers.endIndex {
            if char == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(char)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(mask: "(XXX) XXX-XXXX", phone: newString)
        return false
    }
}
