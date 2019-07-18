//
//  Day+CoreDataClass.swift
//  DevelopU
//
//  Created by Sterling Mortensen on 4/11/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Day)
public class Day: NSManagedObject {

    
    convenience init(dayDate: Date, habitID: String, completionStatus: String, context: NSManagedObjectContext = Stack.context) {
        
        self.init(context: context)
        self.habitID = habitID
        self.completionStatus = completionStatus
        self.dayDate = dayDate as NSDate
    }
    
}
