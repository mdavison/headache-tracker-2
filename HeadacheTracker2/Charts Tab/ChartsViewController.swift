//
//  ChartsViewController.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 6/2/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit
import CoreData
import Charts

class ChartsViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var yearSelectionView: UIView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearStepper: UIStepper!
    
    var coreDataStack: CoreDataStack!
    
    var currentYear: Double {
        get {
            let calendar = Calendar.current
            return Double(calendar.component(.year, from: Date()))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearLabel.text = "\(Int(currentYear))"
        yearStepper.value = currentYear

        setChart(for: Int(currentYear))
    }
    
    
    // MARK: - Actions
    
    @IBAction func updateYear(_ sender: UIStepper) {
        let year = Int(sender.value)
        yearLabel.text = "\(year)"
        setChart(for: year)
    }
    
    
    
    // MARK: - Helpers
    
    private func setChart(for year: Int) {
        barChartView.data = Headache.getBarChartData(for: year, coreDataStack: coreDataStack)
        barChartView.chartDescription?.text = "Total headaches by month"
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .top
        xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = MonthAxisValueFormatter(chart: barChartView)
        
        barChartView.leftAxis.valueFormatter = HeadachesAxisValueFormatter(chart: barChartView)
        barChartView.rightAxis.valueFormatter = HeadachesAxisValueFormatter(chart: barChartView)
        
        barChartView.leftAxis.granularity = 1
        barChartView.rightAxis.granularity = 1
        
    }
    
}
