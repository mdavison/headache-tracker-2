//
//  MockCoreDataStack.swift
//  HeadacheTracker2Tests
//
//  Created by Morgan Davison on 5/17/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import Foundation
import CoreData
@testable import HeadacheTracker2

class TestCoreDataStack: CoreDataStack {
//    private let modelName: String
//
//    override init(modelName: String) {
//        super.init(modelName: modelName)
//
//        self.modelName = modelName
//    }
    
//    private lazy var storeContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: self.modelName)
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                print("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//
//        return container
//    }()
    
//    func saveContext() {
//        guard managedContext.hasChanges else { return }
//
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Unresolved error \(error), \(error.userInfo)")
//        }
//    }
    
//    lazy var managedContext: NSManagedObjectContext = {
//        return self.storeContainer.viewContext
//    }()
}
