//
//  CoreDataStack.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 4/21/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    lazy var managedContext: NSManagedObjectContext = {
        // Use a function call so it can be overridden in the unit test
        return getManagedContext()
    }()
    
    func getManagedContext() -> NSManagedObjectContext {
        return self.storeContainer.viewContext
    }
}
