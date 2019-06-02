//
//  SettingsTableViewController.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 5/19/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit
import os.log
import MobileCoreServices

class SettingsTableViewController: UITableViewController {

    var coreDataStack: CoreDataStack!
    
    struct SettingsStoryboard {
        static let ManageMedicationSegueIdentifier = "SettingsManageMedications"
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SettingsStoryboard.ManageMedicationSegueIdentifier {
            guard
                let navController = segue.destination as? UINavigationController,
                let medicationTableViewController = navController.topViewController as? MedicationTableViewController
                else {
                    os_log("Error: could not get medicationTableViewController", type: .error)
                    
                    return
            }
            
            medicationTableViewController.coreDataStack = coreDataStack
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func export(_ sender: UIButton) {
        
        guard let data = Headache.prepareCSVData(coreDataStack: coreDataStack) else {
            os_log("SettingsTableViewController: Unable to prepare data for export", type: .error)
            
            return
        }
        
        let filename = Utilities.documentsDirectory + "/headaches.csv"
        let url = URL(fileURLWithPath: filename)
        
        do {
            try data.write(to: url)
        } catch let error {
            os_log(.error, "SettingsTableViewController: Unable to write export data to file: %{public}@", error.localizedDescription)
            
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let popoverController = activityViewController.popoverPresentationController {
            let sourceView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            popoverController.sourceView = sourceView
        }
        
        present(activityViewController, animated: true)
    }
}
