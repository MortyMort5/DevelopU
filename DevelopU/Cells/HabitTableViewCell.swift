//
//  HabitTableViewCell.swift
//  DevelopU
//
//  Created by Sterling Mortensen on 4/4/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import UIKit
import CoreData

class HabitTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, updateDayDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: Constant.dayCellIdentifier)
        collectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func updateView() {
        guard let habit = self.habit, let days = habit.days?.array as? [Day] else { return }
        let streak = totalCountCompletedInARow(days: days)
        if habit.streak != streak {
            habit.streak = streak
            HabitController.shared.update(habit: habit)
        }
        
        streakButton.setTitle("\(habit.streak)", for: .normal)
        nameLabel.text = habit.name
    }
    
    func updateDay(sender: DayCollectionViewCell) {
        guard let day = sender.day else { return }
        self.delegate?.updateDay(day: day)
        self.collectionView.reloadData()
    }
    
    func totalCountCompleted(days: [Day]) -> Int32 {
        // Get's the total count completed of the lifespan of the habit
        let totalDaysBool = days.compactMap({ $0.completionStatus == DayCompletion.Completed.rawValue })
        
        return Int32(totalDaysBool.count)
    }
    
    func totalCountCompletedInARow(days: [Day]) -> Int32 {
        // total count completed in a row
        var count = 0
        for day in days {
            if day.completionStatus == DayCompletion.Completed.rawValue {
                count = count + 1
            } else if day.completionStatus == DayCompletion.Excused.rawValue {
                // do nothing to the count when it's an excused day
            } else {
                return Int32(count)
            }
        }
        return Int32(count)
    }
    
    // MARK: - IBActions
    @IBAction func streakButtonTapped(_ sender: Any) {
        
    }
    
    var habit: Habit? {
        didSet {
            self.updateView()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var streakButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    weak var delegate: updateHabitCellDelegate?
}

extension HabitTableViewCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.habit?.days?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.dayCellIdentifier, for: indexPath) as? DayCollectionViewCell else { return UICollectionViewCell() }
        
        cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        let day = self.habit?.days?.object(at: indexPath.row) as! Day

        cell.day = day
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}

protocol updateHabitCellDelegate: class {
    func updateDay(day: Day)
}
