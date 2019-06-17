//
//  HabitViewController.swift
//  DevelopU
//
//  Created by Sterling Mortensen on 4/4/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import UIKit
import CoreData

class HabitViewController: UITableViewController, updateHabitCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "HabitTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.habitCellIdentifier)
        
        setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    deinit {
        print("Deinit Habit")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitController.shared.habits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.habitCellIdentifier, for: indexPath as IndexPath) as? HabitTableViewCell else { return UITableViewCell() }
        
        let habit = HabitController.shared.habits[indexPath.row]
        cell.habit = habit
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let habit = HabitController.shared.habits[indexPath.row]
            HabitController.shared.delete(habit: habit)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    // MARK: - TableViewCell Delegate Protocol 
    func updateDay(day: Day) {
        HabitController.shared.updateDay(day: day)
        self.tableView.reloadData()
    }
    
    // MARK: - Helper Functions
    fileprivate func setupNavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.title = "HABITZ"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabitButtonTapped))
    }
    
    // MARK: - Action Selectors
    @objc func addHabitButtonTapped() {
        let addHabitVC = AddHabitTableViewController()
        self.navigationController?.pushViewController(addHabitVC, animated: true)
    }
}
