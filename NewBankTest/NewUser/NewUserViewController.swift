//
//  NewUserViewController.swift
//  NewBankTest
//
//  Created by Александр Николаев on 23.05.2022.
//

import UIKit
import CoreData


class NewUserViewController: UIViewController {
    
    var user: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        createLabel(text: "Логин",x: -50,y:-300,id: "LoginLabel")
        createInput(x: 50,y:-300,id: "LoginInput")
        createLabel(text: "Пароль",x: -50,y:-250,id: "PasswordLabel")
        createInput(x: 50,y:-250,id: "PasswordInput")
        createLabel(text: "Фамилия",x: -50,y:-200,id: "LastNameLabel")
        createInput(x: 50,y:-200,id: "LastNameInput")
        createLabel(text: "Имя",x: -50,y:-150,id: "FirstNameLabel")
        createInput(x: 50,y:-150,id: "FirstNameInput")
        createLabel(text: "Отчество",x: -50,y:-100,id: "MiddleNameLabel")
        createInput(x: 50,y:-100,id: "MiddleNameInput")
        createButton()
    }

    func createLabel(text:String,x:CGFloat,y:CGFloat,id:String) {
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: 300, height: 100))
        label.text = text
        label.restorationIdentifier = id
        label.tintColor = .black
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: x),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: y),
            label.widthAnchor.constraint(equalToConstant: 190),
            label.heightAnchor.constraint(equalToConstant: 34)
            ])
    }
    func createInput(x:CGFloat,y:CGFloat,id:String) {
        let edit = CustomUITextField(frame: CGRect(x: 0, y: 100, width: 300, height: 100))
        edit.backgroundColor = .white
        edit.restorationIdentifier = id
        view.addSubview(edit)

        edit.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            edit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: x),
            edit.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: y),
            edit.widthAnchor.constraint(equalToConstant: 190),
            edit.heightAnchor.constraint(equalToConstant: 34)
            ])
    }
    func createButton(){
        let button = UIButton(type: .system)
        button.setTitle("Добавить", for: .normal)
        button.restorationIdentifier = "AddNewUserButton"
        button.addTarget(self, action: #selector(addNewUser), for: .touchUpInside)
        view.addSubview(button)
                //позиционирование
                button.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                    button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
                    ])
    }
    @objc func addNewUser() {
        guard let loginInput = view.subviews[1] as? CustomUITextField else{
            return
        }
        guard let passwordInput = view.subviews[3] as? CustomUITextField else{
            return
        }
        guard let lastNameInput = view.subviews[5] as? CustomUITextField else{
            return
        }
        guard let firstNameInput = view.subviews[7] as? CustomUITextField else{
            return
        }
        guard let middleNameInput = view.subviews[9] as? CustomUITextField else{
            return
        }
        save(login: (loginInput.text?.uppercased())!, pass: passwordInput.text!, lastname: lastNameInput.text!, firstname: firstNameInput.text!, middlename: middleNameInput.text!)
    }
    //MARK: - save record
    func save(login:String, pass:String, lastname:String, firstname:String, middlename:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!
        let contact = NSManagedObject(entity: entity, insertInto: managedContext)
        let id = UUID().uuidString
        contact.setValue(login, forKeyPath: "login")
        contact.setValue(pass, forKeyPath: "password")
        contact.setValue(lastname, forKey: "lastname")
        contact.setValue(firstname, forKey: "firstname")
        contact.setValue(middlename, forKey: "middlename")
        contact.setValue(id, forKey: "id")
        do {
            try managedContext.save()
            user.append(contact)
        } catch let error as NSError {
            print("Could not save. \(error.code)")
            if error.code == 133021{
                managedContext.rollback()
                let alert = UIAlertController(title: "Ошибка", message: "Пользователь с таким логином уже существует", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ОК", style: .cancel)  { [unowned self] action in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(cancelAction)
                present(alert, animated: true)
                return
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}
