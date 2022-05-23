//
//  NewUserViewController.swift
//  NewBankTest
//
//  Created by Александр Николаев on 23.05.2022.
//

import UIKit
import SwiftUI

class NewUserViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        createTestLabel()
        createTestInput()
    }

    func createTestLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: 300, height: 100))
        label.text = "Логин"
        label.tintColor = .black
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            label.widthAnchor.constraint(equalToConstant: 190),
            label.heightAnchor.constraint(equalToConstant: 34)
            ])
    }
    func createTestInput() {
        let edit = CustomUITextField(frame: CGRect(x: 0, y: 100, width: 300, height: 100))
        edit.backgroundColor = .white
        view.addSubview(edit)

        edit.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            edit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            edit.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            edit.widthAnchor.constraint(equalToConstant: 190),
            edit.heightAnchor.constraint(equalToConstant: 34)
            ])
    }
}
