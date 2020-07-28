//
//  ViewController.swift
//  Task Tracker
//
//  Created by protel on 23.07.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks: [Task] = []
    var taskTrackerManager = TaskTrackerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        taskTrackerManager.checkIfItIsTheFirstLaunchEver()
        taskTrackerManager.bringSavedTasksFromMemory()
        
        updateTasks()
    }
    
    // Responsible for updating the list
    func updateTasks() {
        tasks.removeAll()
        
        do {
            tasks = try taskTrackerManager.refreshTasks()
        } catch {
            tasks = []
        }
        
        tableView.reloadData()
        
        if tasks.count == 0 {
            tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "allDoneImage"))
            tableView.backgroundView?.contentMode = UIView.ContentMode.scaleAspectFit
        }
        else{
            tableView.backgroundView = UIImageView(image: nil)
        }
    }

    // Directs to task creator page
    @IBAction func clickedAdd(_ sender: UIButton?) {
        let navControllerToPresent = storyboard?.instantiateViewController(identifier: "navContToNewEntryScreen") as! UINavigationController
        let entryScreenToPresent = navControllerToPresent.viewControllers.first as! NewEntryScreenViewController
        entryScreenToPresent.getIdOfTaskFromMainView(taskID: nil, newTaskEntryDelegate: self)
        present(navControllerToPresent, animated: true, completion: nil)

    }

}

extension MainScreenViewController: NewTaskEntryDelegate {
    // Did task creator send a new task?
    func didUserCreateNewTask(_ from: NewEntryScreenViewController) {
        DispatchQueue.main.async {
            self.updateTasks()
        }
    }
}

extension MainScreenViewController: ContainsTableView {
    // Swipe action on list items
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = completeSelectedTaskOnListActionCreator(at: indexPath)
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    
    func completeSelectedTaskOnListActionCreator(at: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "Done") {(action, view, completion) in
            Task.deleteFromCatalog(taskID: self.tasks[at.row].id)
            UserDefaults().set(nil , forKey: "taskID_\(self.tasks[at.row].id)")
            self.updateTasks()
        }
        action.image = #imageLiteral(resourceName: "slideActionFigure")
        action.backgroundColor = UIColor(named: "boxColors")
        return action
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // Creating cells on list
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellOnTableView = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cellOnTableView.textLabel?.text = tasks[indexPath.row].name
        cellOnTableView.backgroundColor = .clear
        cellOnTableView.textLabel?.textColor = .white
        cellOnTableView.textLabel?.shadowOffset = CGSize(width: 1, height: 1)
        cellOnTableView.textLabel?.shadowColor = .black
        cellOnTableView.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        cellOnTableView.detailTextLabel?.text = taskTrackerManager.convertDateToString(format: tasks[indexPath.row].date)
        cellOnTableView.detailTextLabel?.textColor = taskTrackerManager.hasThisDatePassed(tasks[indexPath.row].date) ? .red : .white
        return cellOnTableView
    }
    // Click on list item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let navControllerToPresent = storyboard?.instantiateViewController(identifier: "navContToNewEntryScreen") as! UINavigationController
        let entryScreenToPresent = navControllerToPresent.viewControllers.first as! NewEntryScreenViewController
        entryScreenToPresent.getIdOfTaskFromMainView(taskID: tasks[indexPath.row].id, newTaskEntryDelegate: self)
        present(navControllerToPresent, animated: true, completion: nil)
    }
}
