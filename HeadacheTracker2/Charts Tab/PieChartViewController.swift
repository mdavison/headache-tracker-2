//
//  PieChartViewController.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 6/25/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit
import Charts

class PieChartViewController: UIViewController {

    @IBOutlet weak var yearSelectionView: UIView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearStepper: UIStepper!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var coreDataStack: CoreDataStack!
    var selectedYear: Int?
    
    var currentYear: Int {
        get {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: Date())
            selectedYear = year
            
            return year
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let border = CALayer()
        let borderColor = UIColor(red: 214/255.0, green: 214/255.0, blue: 214/255.0, alpha: 1).cgColor
        border.backgroundColor = borderColor
        border.frame = CGRect(x: 0, y: yearSelectionView.frame.size.height - 1, width: yearSelectionView.frame.size.width, height: 1)
        yearSelectionView.layer.addSublayer(border)
        
        yearLabel.text = "\(currentYear)"
        yearStepper.value = Double(currentYear)
        
        setChart(for: currentYear)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(managedObjectContextObjectsDidChange),
            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: coreDataStack.managedContext)
    }
    
    
    // MARK: - Actions
    
    @IBAction func yearChanged(_ sender: UIStepper) {
        let year = Int(sender.value)
        selectedYear = year
        yearLabel.text = "\(year)"
        setChart(for: year)
    }
    
    
    // MARK: - Notifications
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        if let year = selectedYear {
            setChart(for: year)
        } else {
            setChart(for: currentYear)
        }
    }
    
    

    
    // MARK: - Helpers
    
    private func setChart(for year: Int) {
        pieChartView.noDataText = NSLocalizedString("There is no data for that year.", comment: "")
        pieChartView.data = Headache.getPieChartData(for: year, coreDataStack: coreDataStack)
    }
}
