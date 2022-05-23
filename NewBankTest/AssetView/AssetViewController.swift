//
//  AssetViewController.swift
//  NewBankTest
//
//  Created by Александр Николаев on 18.05.2022.
//

import UIKit
import CoreData

class AssetViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var login:String = ""
    var contactid:String = ""
    var asset: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Карты"
    }
    
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           print("Память утекает AssetViewController")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Asset")
        let predicate = NSPredicate(format: "contactid == %@", self.contactid)
        fetchRequest.predicate = predicate

        do {
            asset = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Новый пользователь", message: "Добавление новой карты", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [unowned self] action in

        guard let textField = alert.textFields?.first,
          let cardToSave = textField.text else {
            return
        }
        guard let textField2 = alert.textFields?[1],
          let amountToSave = textField2.text else {
        return
        }


        self.save(cardnum: cardToSave,amount: amountToSave)
        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addTextField()
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func save(cardnum: String,amount: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Asset", in: managedContext)!
        let card = NSManagedObject(entity: entity, insertInto: managedContext)
        let id = UUID().uuidString
        card.setValue(cardnum, forKeyPath: "cardnum")
        card.setValue(amount, forKeyPath: "amount")
        card.setValue(id, forKey: "id")
        card.setValue(self.contactid, forKey: "contactid")
        do {
            try managedContext.save()
            asset.append(card)
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
extension AssetViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asset.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let card = asset[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let login = self.login
        let cardnum = card.value(forKeyPath: "cardnum") as! String
        let amount = card.value(forKeyPath: "amount") as? String
        let RUB = "\u{20BD}"
        content.text = login + " " + "*" + cardnum.suffix(4)
        content.secondaryText = amount! + " \(RUB)"
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == UITableViewCell.EditingStyle.delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(asset[indexPath.row])
                do {
                    try managedContext.save();
                    asset.remove(at: indexPath.row)
                    tableView.reloadData()
                } catch let error as NSError {
                    print("Could not delete. \(error), \(error.userInfo)")
                }
        }
    }
}
