//
//  UsersViewController.swift
//  NewBankTest
//
//  Created by Александр Николаев on 05.05.2022.
//

import UIKit
import CoreData

class UsersViewController: CustomViewController{
    @IBOutlet weak var tableView: UITableView!
    var user: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Пользователи"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContact()
    }
    
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           print("Память утекает UsersViewController")
    }

    // MARK: - add new user
    @IBAction func addName(_ sender: UIBarButtonItem) {
        let vc = NewUserViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - fetchContact
    private func fetchContact(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")

        do {
            user = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

// MARK: - UITableViewDataSource
extension UsersViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let contact = user[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let login = contact.value(forKeyPath: "login") as! String
        let password = contact.value(forKeyPath: "password") as! String
        content.text = login
        content.secondaryText = password
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == UITableViewCell.EditingStyle.delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(user[indexPath.row])
                do {
                    try managedContext.save();
                    user.remove(at: indexPath.row)
                    tableView.reloadData()
                } catch let error as NSError {
                    print("Could not delete. \(error), \(error.userInfo)")
                }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select:      \(indexPath.row)  ")
        let contact = user[indexPath.row]
        let login = contact.value(forKeyPath: "login") as! String
        let id = contact.value(forKeyPath: "id") as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let AssetViewController = storyboard.instantiateViewController(identifier: "AssetViewController") as? AssetViewController else { return }
        AssetViewController.login = login
        AssetViewController.contactid = id
        navigationController?.pushViewController(AssetViewController, animated: true)
    }
}
