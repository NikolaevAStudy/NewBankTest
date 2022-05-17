//
//  AvatarUIImageView.swift
//  NewBankTest
//
//  Created by Александр Николаев on 15.05.2022.
//

import UIKit

class AvatarUIImageView: UIImageView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    /*
     override func draw(_ rect: CGRect) {
         super.draw(rect)
         self.layer.cornerRadius = 10.0   /// радиус закругления закругление
         self.layer.borderWidth = 2.0   // толщина обводки
         self.layer.borderColor = UIColor.systemRed.cgColor // цвет обводки
         self.clipsToBounds = true  // не забудь это, а то не закруглиться
         self.tintColor = .red
     }
     */

}
