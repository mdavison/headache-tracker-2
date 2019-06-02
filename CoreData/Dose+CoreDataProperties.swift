//
//  Dose+CoreDataProperties.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 5/19/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//
//

import Foundation
import CoreData


extension Dose {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dose> {
        return NSFetchRequest<Dose>(entityName: "Dose")
    }

    @NSManaged public var date: Date
    @NSManaged public var quantity: Int16
    @NSManaged public var headache: Headache
    @NSManaged public var medication: Medication

}
