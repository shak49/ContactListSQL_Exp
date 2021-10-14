//
//  UIViewController.swift
//  ContactList_Exp
//
//  Created by Shak Feizi on 10/14/21.
//

import Foundation
import UIKit


extension UIViewController {
    func showError(_ title: String?,_ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
