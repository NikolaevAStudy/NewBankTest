//
//  MainViewController.swift
//  NewBankTest
//
//  Created by Александр Николаев on 10.05.2022.
//

import UIKit
import CoreData
import Foundation

class MainViewController: CustomViewController {

    @IBOutlet weak var cardsTableView: UITableView!
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
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
        users = fetchRecord(entityName: "Contact", searchSpec: " id == %@", valueForSerch: contactid)
        asset = fetchRecord(entityName: "Asset", searchSpec: " contactid == %@", valueForSerch: contactid)
        let fio = getFIO()
        getCurrency()
        nameLabel.text = fio
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 1.0,delay: 0.2 ,animations: {
            for viewInd in self.viewCollections.indices {
                self.viewCollections[viewInd].center.x += 500
            }
        })
    }
    
    // MARK: - currency course
    private func getCurrency() {
        let RUB = "\u{20BD}"
        var curr :  [String : Any] = [:]
        var currvalUSD :  [String : Any] = [:]
        var currvalEUR :  [String : Any] = [:]
        let url = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any]
            DispatchQueue.main.async(execute: { [unowned self] in
                curr = responseJSON!["Valute"] as! [String : Any]
                currvalUSD = curr["USD"] as! [String : Any]
                currvalEUR = curr["EUR"] as! [String : Any]
                currencyLabel.text = "USD: \(currvalUSD["Value"] ?? "error")\(RUB) \nEUR: \(currvalEUR["Value"] ?? "error")\(RUB)"
            })
        }
        task.resume()
    }
    
    // MARK: - FIO from CoreData
    private func getFIO() ->String{
        let lastName = users[0].value(forKeyPath: "lastname") as! String
        let firstName = users[0].value(forKeyPath: "firstname") as! String
        let middleName = users[0].value(forKeyPath: "middlename") as! String
        return lastName + " " + firstName + " " + middleName
    }
    
    // MARK: - fetch
    private func fetchRecord(entityName:String,searchSpec:String,valueForSerch:String) -> [NSManagedObject]{
        var fetchResult: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return fetchResult
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        if valueForSerch != "" {
            let predicate = NSPredicate(format: searchSpec, valueForSerch)
            fetchRequest.predicate = predicate
        }
        do {
            fetchResult = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchResult
        
    }
    
    // MARK: - Open Users View
    @IBAction func openUserView(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "UsersViewController")
        self.navigationController?.pushViewController(resultViewController, animated: true)
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
        var content = cell.defaultContentConfiguration()
        let cardnum = card.value(forKeyPath: "cardnum") as! String
        let amount = card.value(forKeyPath: "amount") as? String
        let RUB = "\u{20BD}"
        content.text = (amount ?? " ") + RUB
        content.prefersSideBySideTextAndSecondaryText = true
        content.secondaryText = "Номер карты *" + cardnum.suffix(4)
        let imageURL: URL = URL(string: "https://www.vbr.ru/products/w5aa4j144mk.png")!
        let queue = DispatchQueue.global(qos: .utility)
        let date = Date()
        let calendar = Calendar.current
        let nansec = calendar.component(.nanosecond, from: date)
            queue.async{
              if let data = try? Data(contentsOf: imageURL){
                  DispatchQueue.main.async {
                      content.image = UIImage(data: data)
                      let date1 = Date()
                      let calendar1 = Calendar.current
                      let nanse1 = calendar1.component(.nanosecond, from: date1)
                      cell.contentConfiguration = content
                      print("Show image data " + String(nanse1/1000000))
                  }
                  print("Did download  image data " + String(nansec/1000000))
              }
          }
        return cell
    }
}
