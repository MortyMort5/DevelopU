//
//  Habit+CoreDataClass.swift
//  DevelopU
//
//  Created by Sterling Mortensen on 4/25/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//
//

import Foundation
import CoreData


public class Habit: NSManagedObject {

    convenience init(name: String, reminderTime: String, startDate: Date, streak: Int32, uuid: String, habitDescription: String, frequencyDict: [FrequencyType:Any], context: NSManagedObjectContext = Stack.context) {
        
        self.init(context: context)
        self.timestamp = Date() as NSDate
        self.name = name
        self.reminderTime = reminderTime
        self.startDate = startDate as NSDate
        self.streak = streak
        self.uuid = uuid
        self.habitDescription = habitDescription
        self.frequencyDictionary = frequencyDict as NSDictionary
    }
}
