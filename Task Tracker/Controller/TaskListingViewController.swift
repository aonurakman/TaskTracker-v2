//
//  ViewController.swift
//  Task Tracker
//
//  Created by protel on 23.07.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

class TaskListingViewController: UIViewController { // task listing view controller
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks: [Task] = []
    var taskTrackerManager = TaskTrackerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        taskTrackerManager.checkIfFirstLaunchEver()
        taskTrackerManager.bringSavedTasks()
        
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
    
    func presentNewTaskCreator(sendTaskId id: Int?){
        let navControllerToPresent = storyboard?.instantiateViewController(identifier: "NavigationControllerOfNewTaskCreatingView") as! UINavigationController
        let entryScreenToPresent = navControllerToPresent.viewControllers.first as! NewTaskCreatingViewController
        entryScreenToPresent.getIdOfTaskFromMainView(taskID: id, newTaskEntryDelegate: self)
        present(navControllerToPresent, animated: true, completion: nil)
    }

    // Directs to task creator page
    @IBAction func clickedAdd(_ sender: UIButton?) {
        presentNewTaskCreator(sendTaskId: nil)
    }

}

extension TaskListingViewController: NewTaskEntryDelegate {
    // Did task creator send a new task?
    func didUserCreateNewTask(_ from: NewTaskCreatingViewController) {
        self.updateTasks()
    }
}

extension TaskListingViewController: ContainsTableView {
    // Swipe action on list items
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        func completeSelectedTaskOnListActionCreator(at: IndexPath) -> UIContextualAction{
            let action = UIContextualAction(style: .normal, title: "Done") {(action, view, completion) in
                Task.deleteFromCatalog(taskID: self.tasks[at.row].id)
                UserDefaults.deleteTask(id: self.tasks[at.row].id)
                self.updateTasks()
            }
            action.image = #imageLiteral(resourceName: "slideActionFigure")
            action.backgroundColor = UIColor(named: "boxColors")
            return action
        }
        
        let completeAction = completeSelectedTaskOnListActionCreator(at: indexPath)
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    //taskcell oluştur
    // Creating cells on list
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = TaskCell(text: tasks[indexPath.row].name, textColor: .white, textShadowOffset: CGSize(width: 1, height: 1), textShadowColor: .black, textFont: UIFont.boldSystemFont(ofSize: 20.0), detailText: tasks[indexPath.row].date.convertToString(), bgColor: .clear, dateOfElement: tasks[indexPath.row].date, indexPath: indexPath, tableView: tableView)
        
        return taskCell.getTableViewCell()
    }
    // Click on list item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentNewTaskCreator(sendTaskId: tasks[indexPath.row].id)
    }
}
