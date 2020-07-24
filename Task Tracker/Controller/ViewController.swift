//
//  ViewController.swift
//  Task Tracker
//
//  Created by protel on 23.07.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EntryDelegate{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        manager.checkIfFirstTime()
        manager.getFromMemory()
        
        //Let's view our tasks
        updateTasks()
    }
    

    @IBOutlet weak var tableView: UITableView!
    var tasks: [Task] = []
    var updateMode: Bool = false
    var willUpdate: (name: String, notes: String, date: Date, id: Int)?
    var manager = Manager()
    
    
    // Swipe action on list items
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done])
    }
    
    func doneAction(at: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "Done") {(action, view, completion) in
            UserDefaults().set(nil , forKey: "taskID_\(self.tasks[at.row].id)")
            self.updateTasks()
        }
        action.image = .remove
        action.backgroundColor = UIColor(named: "boxColors")
        return action
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    // Creating cells on list
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].name
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.shadowOffset = CGSize(width: 1, height: 1)
        cell.textLabel?.shadowColor = .black
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        cell.detailTextLabel?.text = manager.dateFormatter(format: tasks[indexPath.row].date)
        cell.detailTextLabel?.textColor = manager.isItPassed(tasks[indexPath.row].date) ? .red : .white
        return cell
    }
    // Click on list item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        updateMode = true
        willUpdate = (tasks[indexPath.row].name, tasks[indexPath.row].notes, tasks[indexPath.row].date, tasks[indexPath.row].id)
        clickedAdd(nil)
    }
    
    
    // Did task creator send a new task?
    func didSendNewTask(_ from: EntryViewController) {
        DispatchQueue.main.async {
            self.updateTasks()
        }
    }

    // Responsible for updating the list
    func updateTasks() {
        tasks.removeAll()
        tasks = manager.refreshTasks() ?? []
        tableView.reloadData()
    }

    
    
    // Directs to task creator page
    @IBAction func clickedAdd(_ sender: UIButton?) {
        self.performSegue(withIdentifier: "addNew", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNew" {
            let dest = segue.destination as! UINavigationController
            let destDest = dest.viewControllers.first as! EntryViewController
            destDest.delegate = self
            if updateMode{
                destDest.isForUpdating = true
                destDest.suggestedID = willUpdate?.id
                destDest.suggestedName = willUpdate?.name
                destDest.suggestedNote = willUpdate?.notes
                destDest.suggestedDate = willUpdate?.date
                destDest.title = willUpdate?.name
                updateMode = false
            }
        
        }
    }

}

