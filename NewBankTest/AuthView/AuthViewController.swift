//
//  AuthViewController.swift
//  NewBankTest
//
//  Created by Александр Николаев on 05.05.2022.
//

import UIKit
import CoreData

class AuthViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           print("Память утекает AuthViewController")
    }
    
    @IBAction func authButton(_ sender: UIButton) {
        var users: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")

        do {
            users = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        let userCount = Int(users.count)
        var authFlg = false
        for user in 0...userCount-1{
            let username = users[user].value(forKeyPath: "login") as! String
            let pass = users[user].value(forKeyPath: "password") as! String
            let id = users[user].value(forKeyPath: "id") as! String
            if username == loginTextField.text!
                && pass == passwordTextField.text!{
                authFlg = true
                //let UserViewController = storyboard?.instantiateViewController(identifier: "UsersViewController")
                //navigationController?.pushViewController(UserViewController!, animated: true)
                let MainViewController = MainViewController(contactid: id , nibName: "MainViewController", bundle: self.nibBundle)
                navigationController?.pushViewController(MainViewController, animated: true)
                break
            }
        }
        if authFlg == false{
            let alert = UIAlertController(title: "Ошибка", message: "Ошибка авторизации", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ОК", style: .cancel)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
    @IBAction func newUserButton(_ sender: UIButton) {
        let vc = NewUserViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
