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

    @IBOutlet weak var intervalSelectionView: UIView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var intervalSegmentedControl: UISegmentedControl!
    
    var coreDataStack: CoreDataStack!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let border = CALayer()
        let borderColor = UIColor(red: 214/255.0, green: 214/255.0, blue: 214/255.0, alpha: 1).cgColor
        border.backgroundColor = borderColor
        border.frame = CGRect(x: 0, y: intervalSelectionView.frame.size.height - 1, width: intervalSelectionView.frame.size.width, height: 1)
        intervalSelectionView.layer.addSublayer(border)
        
        setChart(for: ChartInterval.year)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(managedObjectContextObjectsDidChange),
            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: coreDataStack.managedContext)
    }
    
    
    // MARK: - Actions
    
    @IBAction func intervalChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: setChart(for: ChartInterval.week)
        case 1: setChart(for: ChartInterval.month)
        case 2: setChart(for: ChartInterval.year)
        default: return
        }
    }
    
    
    // MARK: - Notifications
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        setChart(for: ChartInterval.year)
    }
    
    
    // MARK: - Helpers
    
    private func setChart(for interval: ChartInterval) {
        pieChartView.noDataText = NSLocalizedString("There is no data for selected time frame.", comment: "")
        pieChartView.data = Headache.getPieChartData(for: interval, coreDataStack: coreDataStack)
    }
}
