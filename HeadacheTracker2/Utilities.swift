//
//  Utilities.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 5/21/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import Foundation

struct Utilities {
    
    static var documentsDirectory: String {
        get {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            
            return paths[0]
        }
    }
}
