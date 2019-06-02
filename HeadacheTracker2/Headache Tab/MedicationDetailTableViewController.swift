//
//  MedicationDetailTableViewController.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 4/30/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit
import CoreData
import os.log

class MedicationDetailTableViewController: UITableViewController {

    @IBOutlet weak var medicationNameTextField: UITextField!
    @IBOutlet weak var dosageDescriptionTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var coreDataStack: CoreDataStack!
    var medication: Medication?
    var medications: [Medication]?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let medication = self.medication {
            self.title = "Edit \(medication.name)"
            medicationNameTextField.text = medication.name
            dosageDescriptionTextField.text = medication.desc
        } else {
            self.title = "New Medication"
            doneButton.isEnabled = false
        }
        
        medicationNameTextField.delegate = self
        dosageDescriptionTextField.delegate = self        
    }
    
    
    // MARK: - Actions
    
    @IBAction func done(_ sender: UIBarButtonItem) {        
        guard
            let medicationNameTextField = view.viewWithTag(1) as? UITextField,
            let medicationDescriptionTextField = view.viewWithTag(2) as? UITextField
            else {
                os_log("Error: Could not find text fields", type: .error)
                return
        }
        
        let medicationName = medicationNameTextField.text
        let dosageDescription = medicationDescriptionTextField.text
        
        let validationError = medicationIsValid(name: medicationName, description: dosageDescription)
        if let errorMessage = validationError {
            showInvalidMedicationAlert(title: "Oops!", message: errorMessage)
            
            return
        }
        
        if medication == nil {
            medication = Medication(context: coreDataStack.managedContext)
        }
        
        if let medication = medication, let medicationName = medicationName {
            medication.name = medicationName
            medication.desc = dosageDescription
        }
        
        coreDataStack.saveContext()
        
        dismiss(animated: true)
    }
    
    
    // MARK: Helper Methods
    
    private func medicationIsValid(name: String?, description: String?) -> String? {
        guard let name = name else {
            os_log("MedicationDetailTableViewController Error: medication text fields are nil", type: .error)
            
            return NSLocalizedString("Name can't be blank.", comment: "Medication Name must have a value.")
        }
        
        return Medication.validate(name: name, with: medications, against: medication)
    }
    
    private func showInvalidMedicationAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}



// MARK: Extensions

// MARK: UITextFieldDelegate

extension MedicationDetailTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("text field: \(textField)")
        
        if textField.tag == 1 {
            if textField.text == "" {
                doneButton.isEnabled = false
                
                return true
            }
        }
        
        doneButton.isEnabled = true
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            if textField.text == "" {
                doneButton.isEnabled = false
            }
        }
        
        doneButton.isEnabled = true
    }
}
