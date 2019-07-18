//
//  DayCollectionViewCell.swift
//  DevelopU
//
//  Created by Sterling Mortensen on 4/4/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    func updateView() {
        guard let day = self.day else { return }
        dayButton.setTitle(day.dayDate?.dayOfWeekLetter(), for: .normal)
        
        switch day.completionStatus {
        case DayCompletion.Completed.rawValue:
            dayButton.layer.backgroundColor = Constant.completedDayColor
        case DayCompletion.Excused.rawValue:
            dayButton.layer.backgroundColor = Constant.excusedColor
        case DayCompletion.Failed.rawValue:
            dayButton.layer.backgroundColor = Constant.failedToCompleteColor
        default:
            dayButton.layer.backgroundColor = Constant.completedDayColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error Day Collection View Cell")
    } 
    
    override func layoutSubviews() {
        dayButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        dayButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dayButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        dayButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        dayButton.addTarget(self, action: #selector(dayButtonTapped(sender:)), for: .touchUpInside)
        dayButton.layer.cornerRadius = dayButton.frame.height/2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(dayButton)
    }
    
    @objc func dayButtonTapped(sender: UIButton!) {
        delegate?.updateDay(sender: self)
    }
    
    weak var delegate: updateDayDelegate?
    
    var day: Day? {
        didSet {
            self.updateView()
        }
    }
    
    let dayButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        return button
    }()
}

protocol updateDayDelegate: class {
    func updateDay(sender: DayCollectionViewCell)
}
