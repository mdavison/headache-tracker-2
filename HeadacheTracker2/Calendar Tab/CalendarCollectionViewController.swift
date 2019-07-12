//
//  CalendarCollectionViewController.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 5/22/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit
import CoreData

class CalendarCollectionViewController: UICollectionViewController {
    
    var coreDataStack: CoreDataStack!
    var madCalendar: MADCalendar?
    
    struct CalendarStoryboard {
        static let CellReuseIdentifier = "CalendarCell"
        static let HeaderReuseIdentifier = "CalendarHeader"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        madCalendar = MADCalendar(coreDataStack: coreDataStack)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(managedObjectContextObjectsDidChange),
            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: coreDataStack.managedContext)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext) in
            self.collectionView?.reloadData()
        }) { (context: UIViewControllerTransitionCoordinatorContext) in
            //
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Notifications
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        collectionView.reloadData()
    }

    

    // MARK: - Helper Methods

    private func configureCell(_ cell: CalendarCollectionViewCell, for indexPath: IndexPath) {
        guard let madCalendar = madCalendar else { return }
        
        cell.severityIndicatorLabel.textColor = .white
        
        DispatchQueue.global(qos: .userInitiated).async {
            let (number, headache) = madCalendar.getDayInfo(for: indexPath)
            
            DispatchQueue.main.async {
                cell.dayNumberLabel.text = number
                if let headache = headache {
                    cell.severityIndicatorLabel.textColor = headache.severityDisplayColor
                }
            }
        }
    }

}


// MARK: UICollectionViewDataSource and Delegate

extension CalendarCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let madCalendar = madCalendar {
            return madCalendar.monthsYears.count
        }
        
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let madCalendar = madCalendar else { return 0 }
        
        let month = madCalendar.monthsYears[section].month
        let year = madCalendar.monthsYears[section].year
        
        return madCalendar.getNumberOfCells(for: month, year: year)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarStoryboard.CellReuseIdentifier,
            for: indexPath) as! CalendarCollectionViewCell
        
        configureCell(cell, for: indexPath)
        
        return cell
    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CalendarStoryboard.HeaderReuseIdentifier,
            for: indexPath) as! CalendarCollectionReusableHeaderView
        
        headerView.backgroundColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1)
        
        var monthName = ""
        if let madCalendar = madCalendar {
            monthName = madCalendar.getMonthName(for: indexPath)
        }
        headerView.monthLabel.text = monthName
        
        return headerView
    }

    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
}


extension CalendarCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(view.bounds.width / 7.0)
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
}
