//
//  Contact+CoreDataProperties.swift
//  NewBankTest
//
//  Created by Александр Николаев on 20.05.2022.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var id: String?
    @NSManaged public var login: String?
    @NSManaged public var password: String?
    @NSManaged public var lastname: String?
    @NSManaged public var firstname: String?
    @NSManaged public var middlename: String?
    @NSManaged public var asset: NSSet?

}

// MARK: Generated accessors for asset
extension Contact {

    @objc(addAssetObject:)
    @NSManaged public func addToAsset(_ value: Asset)

    @objc(removeAssetObject:)
    @NSManaged public func removeFromAsset(_ value: Asset)

    @objc(addAsset:)
    @NSManaged public func addToAsset(_ values: NSSet)

    @objc(removeAsset:)
    @NSManaged public func removeFromAsset(_ values: NSSet)

}

extension Contact : Identifiable {

}
