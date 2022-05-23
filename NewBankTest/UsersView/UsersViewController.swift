//
//  UsersViewController.swift
//  NewBankTest
//
//  Created by Александр Николаев on 05.05.2022.
//

import UIKit
import CoreData

class UsersViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var user: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Пользователи"
        tableView.allowsSelection = true
    }
    
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           print("Память утекает UsersViewController")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Новый пользователь", message: "Добавление нового пользователя", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [unowned self] action in
            
        guard let textField = alert.textFields?.first,
          let nameToSave = textField.text else {
            return
        }
        guard let textField2 = alert.textFields?[1],
          let passToSave = textField2.text else {
        return
        }
        /*guard let textField3 = alert.textFields?.last,
          let urlToSave = textField3.text else {
        return
        }*/

        self.save(name: nameToSave,pass: passToSave)
        self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func save(name: String,pass: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!
        let contact = NSManagedObject(entity: entity, insertInto: managedContext)
        let id = UUID().uuidString
        contact.setValue(name, forKeyPath: "login")
        contact.setValue(pass, forKeyPath: "password")
        contact.setValue(id, forKey: "id")
        do {
            try managedContext.save()
            user.append(contact)
        } catch let error as NSError {
            print("Could not save. \(error.code)")
            if error.code == 133021{
                let alert = UIAlertController(title: "Ошибка", message: "Пользователь с таким логином уже существует", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ОК", style: .cancel)
                alert.addAction(cancelAction)
                present(alert, animated: true)
            }
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
