//
//  Habit+CoreDataProperties.swift
//  DevelopU
//
//  Created by Sterling Mortensen on 4/25/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var habitDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var reminderTime: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var streak: Int32
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var uuid: String?
    @NSManaged public var frequencyDictionary: NSObject?
    @NSManaged public var days: NSMutableOrderedSet?

}

// MARK: Generated accessors for days
extension Habit {

    @objc(insertObject:inDaysAtIndex:)
    @NSManaged public func insertIntoDays(_ value: Day, at idx: Int)

    @objc(removeObjectFromDaysAtIndex:)
    @NSManaged public func removeFromDays(at idx: Int)

    @objc(insertDays:atIndexes:)
    @NSManaged public func insertIntoDays(_ values: [Day], at indexes: NSIndexSet)

    @objc(removeDaysAtIndexes:)
    @NSManaged public func removeFromDays(at indexes: NSIndexSet)

    @objc(replaceObjectInDaysAtIndex:withObject:)
    @NSManaged public func replaceDays(at idx: Int, with value: Day)

    @objc(replaceDaysAtIndexes:withDays:)
    @NSManaged public func replaceDays(at indexes: NSIndexSet, with values: [Day])

    @objc(addDaysObject:)
    @NSManaged public func addToDays(_ value: Day)

    @objc(removeDaysObject:)
    @NSManaged public func removeFromDays(_ value: Day)

    @objc(addDays:)
    @NSManaged public func addToDays(_ values: NSOrderedSet)

    @objc(removeDays:)
    @NSManaged public func removeFromDays(_ values: NSOrderedSet)

}
