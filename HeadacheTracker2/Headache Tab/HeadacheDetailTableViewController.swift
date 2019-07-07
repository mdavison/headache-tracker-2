//
//  HeadacheDetailTableViewController.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 4/28/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit
import os.log

class HeadacheDetailTableViewController: UITableViewController {
    
    var headache: Headache?
    var coreDataStack: CoreDataStack?
    weak var datePicker: UIDatePicker!
    weak var severitySlider: UISlider!
    weak var noteTextView: UITextView!
    var medications = [Medication]()
    var headacheMedicationQuantities = [Medication:Int]()
    
    struct Storyboard {
        static let DatePickerCellReuseIdentifier = "DatePickerCell"
        static let SeverityCellReuseIdentifier = "SeverityCell"
        static let HeadacheMedicationsListCellReuseIdentifier = "HeadacheMedicationsListCell"
        static let HeadacheMedicationsCellReuseIdentifier = "ManageMedicationsCell"
        static let HeadacheNoteCellReuseIdentifier = "HeadacheNoteCell"
        static let ManageMedicationSegueIdentifier = "ManageMedications"
        static let DateSection = 0
        static let SeveritySection = 1
        static let MedicationListSection = 2
        static let ManageMedicationsSection = 3
        static let NoteSection = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let coreDataStack = coreDataStack {
            medications = Medication.fetchAll(coreDataStack: coreDataStack)
        }

        // Populate headache info if editing existing
        if let headache = headache {
            title = "Edit Headache"
            if let hmq = headache.getMedicationsDoses() {
                headacheMedicationQuantities = hmq
            }
        }
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ManageMedicationSegueIdentifier {
            guard
                let navController = segue.destination as? UINavigationController,
                let medicationTableViewController = navController.topViewController as? MedicationTableViewController
                else {
                    os_log("Error: could not get medicationTableViewController", type: .error)
                    
                    return
            }
            
            medicationTableViewController.delegate = self
            medicationTableViewController.coreDataStack = coreDataStack
        }
    }

    
    // MARK: - Actions
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        saveHeadache()
                
        dismiss(animated: true)
    }
    
    @IBAction func severityChanged(_ sender: UISlider) {
        sender.setValue(Float(lroundf(severitySlider.value)), animated: true)
    }
    

    
    
    // MARK: - Helper functions
    
    private func saveHeadache() {
        guard let coreDataStack = coreDataStack, let datePicker = datePicker else { return }
        
        let dateFormatter = ISO8601DateFormatter()
        let formattedDateString = dateFormatter.string(from: datePicker.date)
        let formattedDate = dateFormatter.date(from: formattedDateString)
        
        var editingHeadache = true
        
        // Not editing
        if headache == nil {
            headache = Headache(context: coreDataStack.managedContext)
            editingHeadache = false
        }
        
        guard let headache = headache, let headacheDate = formattedDate else {
            os_log("HeadacheDetailTableViewController: unable to save headache", type: .error)
            
            return
        }
        
        headache.date = headacheDate
        headache.severity = Int16(severitySlider.value)
        headache.note = noteTextView.text
        
        if editingHeadache {
            headache.updateDoses(coreDataStack: coreDataStack, medicationQuantities: headacheMedicationQuantities)
        } else {
            headache.addDoses(coreDataStack: coreDataStack, medicationQuantities: headacheMedicationQuantities)
        }
        
        coreDataStack.saveContext()
    }
    
    private func clearMedication(at indexPath: IndexPath) {
        headacheMedicationQuantities[medications[indexPath.row]] = 0
    }
    
    private func updateHeadacheMedicationQuantities() {
        for (med, _) in headacheMedicationQuantities {
            var found = false
            for m in self.medications {
                if med.name == m.name {
                    found = true
                }
            }
            if found == false {
                headacheMedicationQuantities.removeValue(forKey: med)
            }
        }
    }
}


// MARK: - UITableViewController data source and delegate methods

extension HeadacheDetailTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Storyboard.MedicationListSection:
            return medications.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Storyboard.DateSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.DatePickerCellReuseIdentifier, for: indexPath) as! DatePickerTableViewCell
            datePicker = cell.datePicker
            if let headache = headache, let datePicker = datePicker {
                datePicker.date = headache.date
            }
            
            return cell
        case Storyboard.SeveritySection:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Storyboard.SeverityCellReuseIdentifier, for: indexPath
                ) as! SeverityTableViewCell
            severitySlider = cell.severitySlider
            if let headache = headache {
                cell.severitySlider.value = Float(headache.severity)
            }
            
            return cell
        case Storyboard.MedicationListSection:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Storyboard.HeadacheMedicationsListCellReuseIdentifier,
                for: indexPath) as! HeadacheMedicationTableViewCell
            
            let medication = medications[indexPath.row]
            
            cell.medicationNameLabel.text = medication.name
            cell.medicationDescriptionLabel.text = medication.desc
            
            if let medicationDoseQty = headacheMedicationQuantities[medication] {
                cell.medicationQuantityLabel.text = "\(medicationDoseQty)"
            } else {
                cell.medicationQuantityLabel.text = ""
            }
            
            return cell
        case Storyboard.ManageMedicationsSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.HeadacheMedicationsCellReuseIdentifier, for: indexPath)
            return cell
        case Storyboard.NoteSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.HeadacheNoteCellReuseIdentifier, for: indexPath) as! NoteTableViewCell
            noteTextView = cell.noteTextView
            if let headache = headache {
                noteTextView.text = headache.note
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.HeadacheNoteCellReuseIdentifier, for: indexPath)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Storyboard.MedicationListSection {
            let medication = medications[indexPath.row]
            let cell = tableView.cellForRow(at: indexPath) as? HeadacheMedicationTableViewCell
            
            if let medicationAtIndex = headacheMedicationQuantities[medication] {
                headacheMedicationQuantities[medication] = medicationAtIndex + 1
            } else {
                headacheMedicationQuantities[medication] = 1
            }
            
            let qty = headacheMedicationQuantities[medication] ?? 0
            cell?.medicationQuantityLabel.text = qty > 0 ? "\(qty)" : ""
        }
    }
    

     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Only allow editing row in Medications section
        if indexPath.section == Storyboard.MedicationListSection {
            // No point in clearing medications with 0 quantity
            guard let qty = headacheMedicationQuantities[medications[indexPath.row]] else { return false }
            if qty > 0 {
                return true
            }
            
            return false
        } else {
            return false
        }
     }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let button = UITableViewRowAction(style: .default, title: "Clear") { (action, indexPath) in
            self.clearMedication(at: indexPath)
            
            let cell = tableView.cellForRow(at: indexPath) as? HeadacheMedicationTableViewCell
            cell?.medicationQuantityLabel.text = ""
        }
        button.backgroundColor = .orange
        
        return [button]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Storyboard.DateSection: return 217
        case Storyboard.SeveritySection: return 90
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Storyboard.DateSection: return NSLocalizedString("Date", comment: "")
        case Storyboard.SeveritySection: return NSLocalizedString("Severity", comment: "")
        case Storyboard.MedicationListSection: return NSLocalizedString("Medications", comment: "")
        case Storyboard.NoteSection: return NSLocalizedString("Note", comment: "")
        default: return ""
        }
    }
}


// MARK: MedicationTableViewControllerDelegate

extension HeadacheDetailTableViewController: MedicationTableViewControllerDelegate {

    func medicationTableViewControllerDidFinish(controller: MedicationTableViewController, medications: [Medication]) {
        self.medications = medications
        
        // In case one of the medications in headacheMedicationQuantities was deleted
        updateHeadacheMedicationQuantities()
        
        tableView.reloadSections(IndexSet([2]), with: .automatic)
    }
}
