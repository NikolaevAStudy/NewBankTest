//
//  Contact+CoreDataProperties.swift
//  NewBankTest
//
//  Created by Александр Николаев on 16.05.2022.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var login: String?
    @NSManaged public var password: String?
    @NSManaged public var id: String?
    @NSManaged public var avatarurl: URL?

}

extension Contact : Identifiable {

}
