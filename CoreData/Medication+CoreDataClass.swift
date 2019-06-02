//
//  Medication+CoreDataClass.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 4/29/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Medication)
public class Medication: NSManagedObject {
    
    class func fetchAll(coreDataStack: CoreDataStack) -> [Medication] {
        let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        var medications = [Medication]()
        
        do {
            medications = try coreDataStack.managedContext.fetch(fetchRequest) as [Medication]
        } catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
        
        return medications
    }
    
    class func saveOrCreate(name: String, coreDataStack: CoreDataStack) -> Medication? {
        // Try to fetch
        let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = predicate

        var medications = [Medication]()
        do {
            medications = try coreDataStack.managedContext.fetch(fetchRequest) as [Medication]
        } catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
        
        if let medication = medications.first {
            return medication
        }
        
        // Create
        let allMedications = Medication.fetchAll(coreDataStack: coreDataStack)
        let validationError = Medication.validate(name: name, with: allMedications, against: nil)
        if validationError != nil {
            return nil
        }
        
        let medication = Medication(context: coreDataStack.managedContext)
        medication.name = name
        
        return medication 
    }
    
    
    // MARK: - Helper Methods
    
    class func validate(name: String, with medications: [Medication]?, against medication: Medication?) -> String? {
        // Can't be blank
        let trimmedName = name.trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmedName.count == 0 {
            return NSLocalizedString("Name can't be blank.", comment: "Medication Name must have a value.")
        }
        
        // Check for duplicate
        if let medications = medications {
            for med in medications {
                // If we are editing an existing med, skip
                if med == medication {
                    continue
                }
                
                if med.name == name {
                    return NSLocalizedString("Name already exists", comment: "")
                }
            }
        }

        return nil
    }
}
