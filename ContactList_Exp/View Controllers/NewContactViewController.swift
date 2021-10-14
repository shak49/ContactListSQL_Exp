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
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Shak notes: Actions
    @IBAction func saveButton(_ sender: Any) {
        let id: Int = 0
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        let photoView = profileImageView.image ?? UIImage(systemName: "icons8-user-male-50")
        guard let photo = photoView?.pngData() else { return }
        let contactObject = Contact(id: id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, photo: photo)
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

extension NewContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func addImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                fatalError("Expected a dictionary of images, but was provided the fallowing info: \(info)")
        }
        profileImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}


extension NewContactViewController: UITextViewDelegate {
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) {
        
    }
}
