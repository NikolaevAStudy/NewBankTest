//
//  Asset+CoreDataProperties.swift
//  NewBankTest
//
//  Created by Александр Николаев on 19.05.2022.
//
//

import Foundation
import CoreData


extension Asset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Asset> {
        return NSFetchRequest<Asset>(entityName: "Asset")
    }

    @NSManaged public var amount: String?
    @NSManaged public var cardnum: String?
    @NSManaged public var contactid: String?
    @NSManaged public var id: String?
    @NSManaged public var contact: Contact?

}

extension Asset : Identifiable {

}
