//
//  FrequencyTableViewController.swift
//  DevelopU
//
//  Created by Sterling Mortensen on 4/23/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import UIKit

enum FrequenceCellRow: Int {
    case Daily = 0
    case Selection
    case TimesPerWeek
}

enum DayOfWeek: Int {
    case Sunday
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
}

enum DaySelection {
    case Selected
    case Unselected
}


extension DaySelection {
    var value: UIColor {
        get {
            switch self {
            case .Selected:
                return UIColor.green
            case .Unselected:
                return UIColor.lightGray
            }
        }
    }
}

class FrequencyTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupCells()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == FrequenceCellRow.Selection.rawValue && selectionCellIsOpen {
            return 2
        } else if section == FrequenceCellRow.TimesPerWeek.rawValue && timesPerWeekCellIsOpen {
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case FrequenceCellRow.Daily.rawValue:
            return self.dailyCell
            
        case FrequenceCellRow.Selection.rawValue:
            switch indexPath.row {
            case 0:
                return self.daySelectionCell
            case 1:
                if selectionCellIsOpen {
                    return selectedDaysOptionCell
                }
            default:
                return self.daySelectionCell
            }
            
        case FrequenceCellRow.TimesPerWeek.rawValue:
            switch indexPath.row {
            case 0:
                return self.timesPerWeekCell
            case 1:
                if timesPerWeekCellIsOpen {
                    return self.timesPerWeekDetailCell
                }
            default:
                return self.timesPerWeekCell
            }
        
        default:
            fatalError("Error: Couldn't find cell in Frequency TVC")
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case FrequenceCellRow.Daily.rawValue:
            self.frequencyType = .Daily
            self.toggleSelectedCells()
            
        case FrequenceCellRow.Selection.rawValue:
            self.frequencyType = .SelectedDays
            self.toggleSelectedCells()
            
        case FrequenceCellRow.TimesPerWeek.rawValue:
            self.frequencyType = .TimesPerWeek
            self.toggleSelectedCells()
            
        default:
            fatalError("Error: Couldn't find cell that was selected")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                return 68.0
            }
        }
        
        if indexPath.section == 2 {
            if indexPath.row == 1 {
                return 100.0
            }
        }
        return 50
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.timesPerWeekInt = row + 1
    }
    
    @objc func daysButtonTapped(_ sender: UIButton!) {
        // FIXME: - How to make the day buttons perfectly round on any device.
        print("Height: \(sender.layer.frame.height) --- Width: \(sender.layer.frame.width)")

        let daySelection = daysSelectionDictionary[sender.tag] ?? .Selected
        self.daysSelectionDictionary[sender.tag] = daySelection == .Selected ? .Unselected : .Selected
        setSelectedDaysBackgroundColor()
        self.tableView.reloadData()
        
    }
    
    @objc func saveButtonTapped() {
        switch frequencyType {
        case .Daily:
            self.frequencyDict[.Daily] = FrequencyType.Daily.rawValue
            print("Daily")
        case .SelectedDays:
            var daysArray: [String] = []
            for (key, value) in self.daysSelectionDictionary {
                if value == DaySelection.Selected {
                    if key == DayOfWeek.Sunday.rawValue {
                        daysArray.append(DaysString.Sun.rawValue)
                    } else if key == DayOfWeek.Monday.rawValue {
                        daysArray.append(DaysString.Mon.rawValue)
                    } else if key == DayOfWeek.Tuesday.rawValue {
                        daysArray.append(DaysString.Tue.rawValue)
                    } else if key == DayOfWeek.Wednesday.rawValue {
                        daysArray.append(DaysString.Wed.rawValue)
                    } else if key == DayOfWeek.Thursday.rawValue {
                        daysArray.append(DaysString.Thu.rawValue)
                    } else if key == DayOfWeek.Friday.rawValue {
                        daysArray.append(DaysString.Fri.rawValue)
                    } else if key == DayOfWeek.Saturday.rawValue {
                        daysArray.append(DaysString.Sat.rawValue)
                    }
                }
            }
            self.frequencyDict[.SelectedDays] = daysArray
        case .TimesPerWeek:
            self.frequencyDict[.TimesPerWeek] = self.timesPerWeekInt
        }
        
        self.delegate?.addSelectedDaysToHabit(sender: self)
        self.navigationController?.popViewController(animated: true)
    }
    
    func toggleSelectedCells() {
        switch frequencyType {
        case .Daily:
            self.dailyCell.accessoryType = .checkmark
            self.selectionCellIsOpen = false
            self.timesPerWeekCellIsOpen = false
        case .SelectedDays:
            self.dailyCell.accessoryType = .none
            self.selectionCellIsOpen = selectionCellIsOpen ? false : true
            self.timesPerWeekCellIsOpen = false
        case .TimesPerWeek:
            self.dailyCell.accessoryType = .none
            self.selectionCellIsOpen = false
            self.timesPerWeekCellIsOpen = timesPerWeekCellIsOpen ? false : true
        }
        
        self.tableView.reloadData()
    }
    
    let dailyCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.accessoryType = .checkmark
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = "Daily"
        return cell
    }()
    
    let daySelectionCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = "Select Days"
        return cell
    }()
    
    let timesPerWeekCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = "# Per Week"
        return cell
    }()
    
    let selectedDaysOptionCell: UITableViewCell = {
        let cell = UITableViewCell()
        return cell
    }()
    
    let timesPerWeekDetailCell: UITableViewCell = {
        let cell = UITableViewCell()
        return cell
    }()
    
    let perWeekPickerView: UIPickerView = {
        let view = UIPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.showsSelectionIndicator = true
        return view
    }()
    
    let sundayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(daysButtonTapped(_:)), for: .touchUpInside)
        button.tag = DayOfWeek.Sunday.rawValue
        button.setTitle("SU", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    let mondayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(daysButtonTapped(_:)), for: .touchUpInside)
        button.tag = DayOfWeek.Monday.rawValue
        button.setTitle("MO", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    let tuesdayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(daysButtonTapped(_:)), for: .touchUpInside)
        button.tag = DayOfWeek.Tuesday.rawValue
        button.setTitle("TU", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    let wednesdayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(daysButtonTapped(_:)), for: .touchUpInside)
        button.tag = DayOfWeek.Wednesday.rawValue
        button.setTitle("WE", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    let thursdayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(daysButtonTapped(_:)), for: .touchUpInside)
        button.tag = DayOfWeek.Thursday.rawValue
        button.setTitle("TH", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    let fridayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(daysButtonTapped(_:)), for: .touchUpInside)
        button.tag = DayOfWeek.Friday.rawValue
        button.setTitle("FR", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    let saturdayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(daysButtonTapped(_:)), for: .touchUpInside)
        button.tag = DayOfWeek.Saturday.rawValue
        button.setTitle("SA", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    let daysStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = UIColor.brown
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    var selectionCellIsOpen = false
    var timesPerWeekCellIsOpen = false
    weak var delegate: FrequencyDelegate?
    var daysSelectionDictionary: [Int:DaySelection] = [DayOfWeek.Sunday.rawValue: .Selected,
                                              DayOfWeek.Monday.rawValue: .Selected,
                                              DayOfWeek.Tuesday.rawValue: .Selected,
                                              DayOfWeek.Wednesday.rawValue: .Selected,
                                              DayOfWeek.Thursday.rawValue: .Selected,
                                              DayOfWeek.Friday.rawValue: .Selected,
                                              DayOfWeek.Saturday.rawValue: .Selected]
    var frequencyDict: [FrequencyType:Any] = [:]
    var frequencyType: FrequencyType = .Daily
    var timesPerWeekInt: Int = 1
}

extension FrequencyTableViewController {
    fileprivate func setupCells() {
        setSelectedDaysBackgroundColor()
        
        self.daysStackView.addArrangedSubview(sundayButton)
        self.daysStackView.addArrangedSubview(mondayButton)
        self.daysStackView.addArrangedSubview(tuesdayButton)
        self.daysStackView.addArrangedSubview(wednesdayButton)
        self.daysStackView.addArrangedSubview(thursdayButton)
        self.daysStackView.addArrangedSubview(fridayButton)
        self.daysStackView.addArrangedSubview(saturdayButton)
        
        
        sundayButton.layer.cornerRadius = selectedDaysOptionCell.contentView.frame.height / 2
        mondayButton.layer.cornerRadius = selectedDaysOptionCell.contentView.frame.height / 2
        tuesdayButton.layer.cornerRadius = selectedDaysOptionCell.contentView.frame.height / 2
        wednesdayButton.layer.cornerRadius = selectedDaysOptionCell.contentView.frame.height / 2
        thursdayButton.layer.cornerRadius = selectedDaysOptionCell.contentView.frame.height / 2
        fridayButton.layer.cornerRadius = selectedDaysOptionCell.contentView.frame.height / 2
        saturdayButton.layer.cornerRadius = selectedDaysOptionCell.contentView.frame.height / 2
        
        self.selectedDaysOptionCell.contentView.addSubview(daysStackView)
        
        daysStackView.leadingAnchor.constraint(equalTo: selectedDaysOptionCell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        daysStackView.topAnchor.constraint(equalTo: selectedDaysOptionCell.contentView.layoutMarginsGuide.topAnchor).isActive = true
        daysStackView.trailingAnchor.constraint(equalTo: selectedDaysOptionCell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        daysStackView.bottomAnchor.constraint(equalTo: selectedDaysOptionCell.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        self.perWeekPickerView.dataSource = self
        self.perWeekPickerView.delegate = self
        self.timesPerWeekDetailCell.contentView.addSubview(perWeekPickerView)
        
        perWeekPickerView.leadingAnchor.constraint(equalTo: timesPerWeekDetailCell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        perWeekPickerView.topAnchor.constraint(equalTo: timesPerWeekDetailCell.contentView.layoutMarginsGuide.topAnchor).isActive = true
        perWeekPickerView.trailingAnchor.constraint(equalTo: timesPerWeekDetailCell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        perWeekPickerView.bottomAnchor.constraint(equalTo: timesPerWeekDetailCell.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    fileprivate func setSelectedDaysBackgroundColor() {
        self.sundayButton.backgroundColor = self.daysSelectionDictionary[DayOfWeek.Sunday.rawValue]?.value
        self.mondayButton.backgroundColor = self.daysSelectionDictionary[DayOfWeek.Monday.rawValue]?.value
        self.tuesdayButton.backgroundColor = self.daysSelectionDictionary[DayOfWeek.Tuesday.rawValue]?.value
        self.wednesdayButton.backgroundColor = self.daysSelectionDictionary[DayOfWeek.Wednesday.rawValue]?.value
        self.thursdayButton.backgroundColor = self.daysSelectionDictionary[DayOfWeek.Thursday.rawValue]?.value
        self.fridayButton.backgroundColor = self.daysSelectionDictionary[DayOfWeek.Friday.rawValue]?.value
        self.saturdayButton.backgroundColor = self.daysSelectionDictionary[DayOfWeek.Saturday.rawValue]?.value
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Frequency"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
    }
}

protocol FrequencyDelegate: class {
    func addSelectedDaysToHabit(sender: FrequencyTableViewController)
}
