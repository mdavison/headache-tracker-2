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
    
    var currentYear: Int {
        get {
            let calendar = Calendar.current
            return calendar.component(.year, from: Date())
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
    }
    
    
    // MARK: - Actions
    
    @IBAction func yearChanged(_ sender: UIStepper) {
        let year = Int(sender.value)
        yearLabel.text = "\(year)"
        setChart(for: year)
    }
    

    
    // MARK: - Helpers
    
    private func setChart(for year: Int) {
        pieChartView.noDataText = NSLocalizedString("There is no data for that year.", comment: "")
        pieChartView.data = Headache.getPieChartData(for: year, coreDataStack: coreDataStack)
    }
}
