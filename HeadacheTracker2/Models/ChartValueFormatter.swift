//
//  ChartValueFormatter.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 6/2/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import Foundation
import Charts

public class MonthAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    let months = ["Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]
    
    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        // Convert 1-based index of value to 0-based index
        return months[Int(value - 1)]
    }
}

public class HeadachesAxisValueFormatter: DefaultAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    
    init(chart: BarLineChartViewBase) {
        super.init(decimals: 0)
        
        self.chart = chart
    }
    
}
