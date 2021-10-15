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
        loadData()
        tableView.reloadData()
    }
    
    // Shak notes: Functions
    func loadData() {
        viewModel.loadDataFromDatabase()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = viewModel.cellForRowAt(indexPath: indexPath)
        cell.textLabel?.text = contact.firstName + " " + contact.lastName
        cell.detailTextLabel?.textColor = UIColor.systemBlue
        cell.detailTextLabel?.text = contact.phoneNumber
        return cell
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
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
