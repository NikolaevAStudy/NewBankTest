//
//  MainViewController.swift
//  NewBankTest
//
//  Created by Александр Николаев on 10.05.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {


    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet var viewCollections: [UIView]!
    var contactid:String
    var users: [NSManagedObject] = []
    
        
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        let predicate = NSPredicate(format: " id == %@", contactid)
        fetchRequest.predicate = predicate

        do {
            users = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        let imageURL: URL = users[0].value(forKeyPath: "avatarurl") as! URL
        //let imageURL: URL = avatarURL
        let queue = DispatchQueue.global(qos: .utility)
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
          }
    }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           print("Память утекает MainViewController")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 1.0,delay: 0.2 ,animations: {
            self.avatarImage.center.x -= 500
            for viewInd in self.viewCollections.indices {
                self.viewCollections[viewInd].center.x -= 500
            }
        })
    }
}
