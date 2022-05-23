//
//  MainViewController.swift
//  NewBankTest
//
//  Created by Александр Николаев on 10.05.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    @IBOutlet weak var cardsTableView: UITableView!
    
    
    @IBOutlet var viewCollections: [UIView]!
    var contactid:String
    var users: [NSManagedObject] = []
    var asset: [NSManagedObject] = []
    
        
    init(contactid: String, nibName: String?, bundle: Bundle?) {
        self.contactid = contactid
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let contactFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        let assetFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Asset")
        let contactPredicate = NSPredicate(format: " id == %@", contactid)
        let assetPredicate = NSPredicate(format: " contactid == %@", contactid)
        contactFetchRequest.predicate = contactPredicate
        assetFetchRequest.predicate = assetPredicate

        do {
            users = try managedContext.fetch(contactFetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        //let imageURL: URL = users[0].value(forKeyPath: "avatarurl") as! URL
        /*let queue = DispatchQueue.global(qos: .utility)
        let date = Date()
        let calendar = Calendar.current
        let nansec = calendar.component(.nanosecond, from: date)
            queue.async{
              if let data = try? Data(contentsOf: imageURL){
                  DispatchQueue.main.async { [self] in
                      avatarImage.image = UIImage(data: data)
                      let date1 = Date()
                      let calendar1 = Calendar.current
                      let nanse1 = calendar1.component(.nanosecond, from: date1)
                      print("Show image data " + String(nanse1/1000000))
                  }
                  print("Did download  image data " + String(nansec/1000000))
              }
          }*/
        do {
            self.asset = try managedContext.fetch(assetFetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           print("Память утекает MainViewController")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 1.0,delay: 0.2 ,animations: {
            for viewInd in self.viewCollections.indices {
                self.viewCollections[viewInd].center.x -= 500
            }
        })
    }
}
// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return asset.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let card = asset[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cardnum = card.value(forKeyPath: "cardnum") as! String
        let amount = card.value(forKeyPath: "amount") as? String
        let cellstr = "Номер карты " + cardnum + " Сумма " + (amount ?? " ")
        cell.textLabel?.text = cellstr
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
