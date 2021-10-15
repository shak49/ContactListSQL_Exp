//
//  ContactListTableViewController.swift
//  ContactList_Exp
//
//  Created by Shak Feizi on 10/14/21.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    // Shak notes: Properties
    private var viewModel = ContactListVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        viewModel.connectToDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // Shak notes: Functions
    func loadData() {
        DispatchQueue.main.async {
            self.viewModel.loadDataFromDatabase()
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = viewModel.cellForRowAt(indexPath: indexPath)
        cell.textLabel?.text = contact.firstName + " " + contact.lastName
        cell.detailTextLabel?.textColor = UIColor.systemRed
        cell.detailTextLabel?.text = contact.phoneNumber
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = viewModel.cellForRowAt(indexPath: indexPath)
            SQLCommands.delete(contactID: contact.id)
            DispatchQueue.main.async {
                self.loadData()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateView" {
            guard let destination = segue.destination as? NewContactViewController else { return }
            guard let sender = sender as? UITableViewCell else { return }
            if let indexPath = tableView.indexPath(for: sender) {
                let objectToSend = viewModel.cellForRowAt(indexPath: indexPath)
                destination.viewModel = NewContactVM(contact: objectToSend)
            }
        }
    }

}
