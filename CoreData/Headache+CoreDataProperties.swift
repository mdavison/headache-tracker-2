//
//  Headache+CoreDataProperties.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 5/19/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//
//

import Foundation
import CoreData


extension Headache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Headache> {
        return NSFetchRequest<Headache>(entityName: "Headache")
    }

    @NSManaged public var date: Date
    @NSManaged public var note: String?
    @NSManaged public var severity: Int16
    @NSManaged public var doses: NSSet?

}

// MARK: Generated accessors for doses
extension Headache {

    @objc(addDosesObject:)
    @NSManaged public func addToDoses(_ value: Dose)

    @objc(removeDosesObject:)
    @NSManaged public func removeFromDoses(_ value: Dose)

    @objc(addDoses:)
    @NSManaged public func addToDoses(_ values: NSSet)

    @objc(removeDoses:)
    @NSManaged public func removeFromDoses(_ values: NSSet)

}
