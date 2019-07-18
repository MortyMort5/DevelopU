//
//  HabitController.swift
//  DevelopU
//
//  Created by Sterling Mortensen on 4/4/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import Foundation
import CoreData

class HabitController {
    
    static let shared = HabitController()
    
    var habits: [Habit] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Habit")
        if let habits = try? Stack.context.fetch(request) as? [Habit] {
            for habit in habits {
                habit.days?.sort(using: [NSSortDescriptor(key: "dayDate", ascending: false)])
            }
            return habits
        } else { return [] }
    }
    
    func addHabit(name: String, reminderTime: String, startDate: Date, frequency: [FrequencyType:Any], habitDescription: String, frequencyType: FrequencyType) {
        let habit = Habit(name: name, reminderTime: reminderTime, startDate: startDate, streak: 0, uuid: UUID().uuidString, habitDescription: habitDescription, frequencyDict: frequency)
        
        if DateHelper.compareDateToToday(timestamp: startDate) {
            let day = Day(dayDate: startDate, habitID: habit.uuid ?? "", completionStatus: DayCompletion.Completed.rawValue)
            habit.addToDays(day)
            print("Saved Day and Habit")
            self.saveToPersistentStorage()
        } else {
            switch frequencyType {
            case .Daily:
                self.createDaysDaily(forHabit: habit, changingDate: startDate)
            case .SelectedDays:
                guard let days = frequency[FrequencyType.SelectedDays] as? [String] else { return }
                self.createDaysForSelection(habit: habit, changingDate: startDate, selectedDays: days)
            case .TimesPerWeek:
                self.createDaysForTimesPerWeek(habit: habit, changingDate: startDate)
            }
        }
    }
    
    func createDaysForSelection(habit: Habit, changingDate: Date, selectedDays: [String]) {
        let matchesTodaysDate = DateHelper.compareDateToToday(timestamp: changingDate)
        var changingDate = changingDate
        var completionStatus: DayCompletion = .Completed
        
        if !matchesTodaysDate {
            changingDate = changingDate.incrementDateByOneDay()
            if !dateIsSelected(date: changingDate, selectedDays: selectedDays) {
                completionStatus = .Excused
            }
            let day = Day(dayDate: changingDate, habitID: habit.uuid ?? "", completionStatus: completionStatus.rawValue)
            print(day)
            habit.addToDays(day)
            self.saveToPersistentStorage()
            print("Saved Day")
            createDaysForSelection(habit: habit, changingDate: changingDate, selectedDays: selectedDays)
        } else { return }
    }
    
    func createDaysForTimesPerWeek(habit: Habit, changingDate: Date) {
        
    }
    
    func createDaysDaily(forHabit habit: Habit, changingDate: Date) {
        let matchesTodaysDate = DateHelper.compareDateToToday(timestamp: changingDate)
        var changingDate = changingDate
        
        if !matchesTodaysDate {
            changingDate = changingDate.incrementDateByOneDay()
            
            let day = Day(dayDate: changingDate, habitID: habit.uuid ?? "", completionStatus: DayCompletion.Completed.rawValue)
            habit.addToDays(day)
            self.saveToPersistentStorage()
            print("Saved Day")
            createDaysDaily(forHabit: habit, changingDate: changingDate)
        } else { return }
    }
    
    func dateIsSelected(date: Date, selectedDays: [String]) -> Bool {
        return selectedDays.contains(DateHelper.dayOfWeekLetter(date: date))
    }
    
    func delete(habit: Habit) {
        habit.managedObjectContext?.delete(habit)
        saveToPersistentStorage()
        print("Deleted Habit")
    }
    
    func update(habit: Habit) {
        print("updated Habit")
        saveToPersistentStorage()
    }
    
    func updateDay(day: Day) {
        day.completionStatus = DayCompletion.Completed.rawValue == day.completionStatus ? DayCompletion.Failed.rawValue : DayCompletion.Completed.rawValue
        print("Updated Day")
        saveToPersistentStorage()
    }
    
    func saveToPersistentStorage() {
        do {
            try Stack.context.save()
        } catch let error {
            print("error saving persistently \(error.localizedDescription)")
        }
    }
}
