//
//  MedicationTableViewController.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 4/28/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit
import CoreData

protocol MedicationTableViewControllerDelegate: class {
    func medicationTableViewControllerDidFinish(controller: MedicationTableViewController, medications: [Medication])
}

class MedicationTableViewController: UITableViewController {
    
    var coreDataStack: CoreDataStack!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Medication> = {
        let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
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
    
    weak var delegate: MedicationTableViewControllerDelegate?
    
    struct Storyboard {
        static let MedicationCellReuseIdentifier = "MedicationCell"
        static let NewMedicationDetailSegueIdentifier = "NewMedicationDetailSegue"
        static let EditMedicationDetailSegueIdentifier = "EditMedicationDetailSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let navController = segue.destination as? UINavigationController,
            let medicationDetailViewController = navController.topViewController as? MedicationDetailTableViewController
            else { return }
        
        medicationDetailViewController.coreDataStack = coreDataStack
        medicationDetailViewController.medications = fetchedResultsController.fetchedObjects ?? []
        
        if segue.identifier == Storyboard.EditMedicationDetailSegueIdentifier {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let medication = fetchedResultsController.object(at: indexPath)
            
            medicationDetailViewController.medication = medication
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {}
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        guard let medications = fetchedResultsController.fetchedObjects else { return }
        
        delegate?.medicationTableViewControllerDidFinish(controller: self, medications: medications)
        
        dismiss(animated: true)
    }
    
}


// MARK: - UITableView data source and delegate methods

extension MedicationTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MedicationCellReuseIdentifier, for: indexPath)
        
        let medication = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = medication.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let medication = fetchedResultsController.object(at: indexPath)
            fetchedResultsController.managedObjectContext.delete(medication)
            coreDataStack.managedContext.delete(medication)
            coreDataStack.saveContext()
        } 
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}


// MARK: - NSFetchedResultsControllerDelegate

extension MedicationTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
}
