//
//  Constant.swift
//  DevelopU
//
//  Created by Sterling Mortensen on 4/4/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import UIKit

struct Constant {
    static let addHabitSegue = "addHabitSegue"
    static let habitCellIdentifier = "habitCell"
    static let dayCellIdentifier = "dayCell"
    static let dateFormatKey = "MM-dd-yyyy"
    
    // MARK: - Day Collection View Cell Colors
    static let completedDayColor: CGColor = UIColor(red: 253/255,
                                                    green: 216/255,
                                                    blue: 92/255,
                                                    alpha: 1.0).cgColor
    
    static let failedToCompleteColor: CGColor = UIColor(red: 88/255,
                                                        green: 89/255,
                                                        blue: 91/255,
                                                        alpha: 1.0).cgColor
    
    static let excusedColor: CGColor = UIColor(red: 253/255,
                                               green: 6/255,
                                               blue: 92/255,
                                               alpha: 1.0).cgColor
}
