//
//  CustomUITextField.swift
//  NewBankTest
//
//  Created by Александр Николаев on 10.05.2022.
//

import UIKit

class CustomUITextField: UITextField {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 10.0   /// радиус закругления закругление
        self.layer.borderWidth = 2.0   // толщина обводки
        self.layer.borderColor = UIColor(red: 208/255, green: 70/255, blue: 86/255, alpha: 1.0).cgColor // цвет обводки
        self.clipsToBounds = true  // не забудь это, а то не закруглиться
        self.tintColor = .red
    }
}
