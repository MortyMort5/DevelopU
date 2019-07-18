//
//  AddHabitTableViewController.swift
//  DevelopU
//
//  Created by Sterling Mortensen on 4/11/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import UIKit

enum CellRow: Int {
    case NameCellIndex = 0
    case DescriptionCellIndex
    case FrequencyCellIndex
    case ReminderCellIndex
    case StartDateCellIndex
    case LDSCellIndex
}

enum FrequencyType: String {
    case Daily
    case SelectedDays
    case TimesPerWeek
}

class AddHabitTableViewController: UITableViewController, FrequencyDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupCells()
    }
    
    deinit {
        print("Deinit Add Habit")
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == CellRow.ReminderCellIndex.rawValue && reminderTimeCellIsOpen {
            return 2
        } else if section == CellRow.StartDateCellIndex.rawValue && startDateCellIsOpen {
            return 2
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch indexPath.section {
            case CellRow.NameCellIndex.rawValue:
                return self.nameCell
                
            case CellRow.DescriptionCellIndex.rawValue:
                return self.descriptionCell
                
            case CellRow.FrequencyCellIndex.rawValue:
                self.frequencyCell.detailTextLabel?.text = self.frequencyStringFormatter(dict: self.frequencyDictionary)
                return self.frequencyCell
                
            case CellRow.ReminderCellIndex.rawValue:
                switch indexPath.row {
                case 0:
                    return self.reminderTimeCell
                case 1:
                    if reminderTimeCellIsOpen {
                        return self.remindersDetailCell
                    }
                default:
                    return self.remindersDetailCell
                }
                
            case CellRow.StartDateCellIndex.rawValue:
                switch indexPath.row {
                case 0:
                    return self.startDateCell
                case 1:
                    if startDateCellIsOpen {
                        return self.startDateDetailCell
                    }
                default:
                    return self.startDateCell
                }
                
            case CellRow.LDSCellIndex.rawValue:
                return ldsCell
                
            case CellRow.LDSCellIndex.rawValue:
                return ldsCell
                
            default:
                fatalError("Unknown Cell")
            }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if reminderTimeCellIsOpen {
            self.reminderTimeCellIsOpen = false
            self.tableView.reloadData()
            return
        }
        
        switch indexPath.section {
        case CellRow.FrequencyCellIndex.rawValue:
            let frequencyVC = FrequencyTableViewController()
            frequencyVC.delegate = self
            self.navigationController?.pushViewController(frequencyVC, animated: true)
            
        case CellRow.ReminderCellIndex.rawValue:
            self.reminderTimeCellIsOpen = self.reminderTimeCellIsOpen ? false : true
            self.tableView.reloadData()
            
        case CellRow.StartDateCellIndex.rawValue:
            self.startDateCellIsOpen = self.startDateCellIsOpen ? false : true
            self.tableView.reloadData()
            
        case CellRow.LDSCellIndex.rawValue:
            print("test")
            
        default:
            fatalError("Unknown Cell Selected")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == CellRow.DescriptionCellIndex.rawValue {
            return descriptionCellHeight
        } else if indexPath.section == CellRow.ReminderCellIndex.rawValue && reminderTimeCellIsOpen {
            if indexPath.row == 1 {
                return datePickerCellHeight
            }
        } else if indexPath.section == CellRow.StartDateCellIndex.rawValue && startDateCellIsOpen {
            if indexPath.row == 1 {
                return datePickerCellHeight
            }
        }
        return cellHeight
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // Delegate Functions
    func addSelectedDaysToHabit(sender: FrequencyTableViewController) {
        let freqDict = sender.frequencyDict
        self.frequencyDictionary = freqDict
        self.tableView.reloadData()
    }
    
    func frequencyStringFormatter(dict: [FrequencyType:Any]) -> String {
        switch dict.keys.first ?? .Daily {
        case .Daily:
            return FrequencyType.Daily.rawValue
        case .SelectedDays:
            let days = dict[FrequencyType.SelectedDays] as? [String] ?? []
            return days.concatenate()
        case .TimesPerWeek:
            let perWeek = dict[FrequencyType.TimesPerWeek] as? Int ?? 0
            return "\(perWeek)x per week"
        }
    }

    @objc func saveButtonTapped() {
        guard let name = self.nameTextField.text, !name.isEmpty else { return }
        
        let reminderTime = self.reminderTimeCell.detailTextLabel?.text ?? ""
        let description = self.descriptionTextView.text ?? ""
        let startDate = startDatePickerView.date
        let frequencyType = self.frequencyDictionary.keys.first ?? .Daily
        
        HabitController.shared.addHabit(name: name, reminderTime: reminderTime, startDate: startDate, frequency: self.frequencyDictionary, habitDescription: description, frequencyType: frequencyType)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ldsSwitchTapped(_ sender: UISwitch!) {
        
    }
    
    @objc func startDatePickerChanged(_ sender:UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        self.startDateCell.detailTextLabel?.text = formatter.string(from: sender.date)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker!) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = . short
        self.reminderTimeCell.detailTextLabel?.text = formatter.string(from: sender.date)
    }
    
    let nameCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        return cell
    }()
    
    let descriptionCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        return cell
    }()
    
    let reminderTimeCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = "Reminders: "
        return cell
    }()
    
    let frequencyCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = "Frequency: "
        return cell
    }()
    
    let ldsCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = "LDS?"
        return cell
    }()
    
    let startDateCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = "Start Date: "
        return cell
    }()
    
    let startDateDetailCell: UITableViewCell = {
        let cell = UITableViewCell()
        return cell
    }()
    
    let remindersDetailCell: UITableViewCell = {
        let cell = UITableViewCell()
        return cell
    }()
    
    var nameTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "habit name:"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.borderStyle = .roundedRect
        text.font = UIFont.systemFont(ofSize: 14)
        return text
    }()
    
    var descriptionTextView: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 0.5
        text.font = UIFont.systemFont(ofSize: 14)
        return text
    }()
    
    let ldsSwitch: UISwitch = {
        let switched = UISwitch()
        switched.translatesAutoresizingMaskIntoConstraints = false
        switched.addTarget(self, action: #selector(ldsSwitchTapped(_:)), for: .valueChanged)
        switched.isOn = false
        return switched
    }()
    
    let timePickerView: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.backgroundColor = UIColor.white
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    let startDatePickerView: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        picker.backgroundColor = UIColor.white
        picker.addTarget(self, action: #selector(startDatePickerChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    private let cellHeight: CGFloat = 50
    private let descriptionCellHeight: CGFloat = 70
    private let datePickerCellHeight: CGFloat = 120
    var frequencyDictionary:[FrequencyType:Any] = [FrequencyType.Daily:"Daily"]
    var reminderTimeCellIsOpen = false
    var startDateCellIsOpen = false
}

extension AddHabitTableViewController {
    fileprivate func setupNavBar() {
        navigationItem.title = "Add Habit"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }
    
    fileprivate func setupCells() {
        self.nameCell.contentView.addSubview(nameTextField)
        self.descriptionCell.contentView.addSubview(descriptionTextView)
        self.ldsCell.accessoryView = ldsSwitch
        self.remindersDetailCell.contentView.addSubview(timePickerView)
        self.startDateDetailCell.contentView.addSubview(startDatePickerView)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        self.startDateCell.detailTextLabel?.text = formatter.string(from: Date())
        
        timePickerView.leadingAnchor.constraint(equalTo: remindersDetailCell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        timePickerView.trailingAnchor.constraint(equalTo: remindersDetailCell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        timePickerView.topAnchor.constraint(equalTo: remindersDetailCell.contentView.layoutMarginsGuide.topAnchor).isActive = true
        timePickerView.bottomAnchor.constraint(equalTo: remindersDetailCell.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        nameTextField.leadingAnchor.constraint(equalTo: nameCell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: nameCell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameCell.contentView.layoutMarginsGuide.topAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameCell.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        descriptionTextView.leadingAnchor.constraint(equalTo: descriptionCell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: descriptionCell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: descriptionCell.contentView.layoutMarginsGuide.topAnchor).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: descriptionCell.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        startDatePickerView.leadingAnchor.constraint(equalTo: startDateDetailCell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        startDatePickerView.trailingAnchor.constraint(equalTo: startDateDetailCell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        startDatePickerView.topAnchor.constraint(equalTo: startDateDetailCell.contentView.layoutMarginsGuide.topAnchor).isActive = true
        startDatePickerView.bottomAnchor.constraint(equalTo: startDateDetailCell.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
    }
}
