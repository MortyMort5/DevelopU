//
//  Day+CoreDataProperties.swift
//  DevelopU
//
//  Created by Sterling Mortensen on 4/18/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        let request = NSFetchRequest<Day>(entityName: "Day")
        request.sortDescriptors = [NSSortDescriptor(key: "dayDate", ascending: false)]
        return request
    }

    @NSManaged public var completionStatus: String?
    @NSManaged public var habitID: String?
    @NSManaged public var dayDate: NSDate?
    @NSManaged public var habit: Habit?

}
