//
//  HeadacheTableViewController.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 4/28/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit
import CoreData

class HeadacheTableViewController: UITableViewController {

    var coreDataStack: CoreDataStack!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Headache> = {
        let fetchRequest: NSFetchRequest<Headache> = Headache.fetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    struct Storyboard {
        static let HeadacheCellReuseIdentifier = "HeadacheCell"
        static let AddHeadacheSegueIdentifier = "AddHeadache"
        static let EditHeadacheSegueIdentifier = "EditHeadache"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 85
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let navController = segue.destination as? UINavigationController,
            let detailTableViewController = navController.topViewController as? HeadacheDetailTableViewController
            else { return }
        
        if segue.identifier == Storyboard.EditHeadacheSegueIdentifier {
            guard let indexPath = tableView.indexPath(for: sender as! UITableViewCell) else { return }
            
            let headache = fetchedResultsController.object(at: indexPath)
            detailTableViewController.headache = headache
        }
        
        detailTableViewController.coreDataStack = coreDataStack
    }
    
    
    // MARK: - Actions
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {}
    
    
    // MARK: - Helper Methods
    
    private func configureCell(cell: HeadacheTableViewCell, for indexPath: IndexPath) {
                
        let headache = fetchedResultsController.object(at: indexPath)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        guard let headacheDate = headache.date as Date? else { return }
        
        cell.dateLabel?.text = dateFormatter.string(from: headacheDate)
        cell.medicationsLabel?.text = headache.getMedicationsString()
        cell.severityLabel?.textColor = headache.severityDisplayColor
        cell.severityLabel?.text = headache.severityDisplayText
    }

}


// MARK: - UITableViewController Data Source and Delegate methods

extension HeadacheTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.HeadacheCellReuseIdentifier, for: indexPath) as! HeadacheTableViewCell
        
        configureCell(cell: cell, for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
     }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let headache = fetchedResultsController.object(at: indexPath)
            coreDataStack.managedContext.delete(headache)
            
            coreDataStack.saveContext()            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

}



// MARK: - NSFetchedResultsControllerDelegate

extension HeadacheTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
}
