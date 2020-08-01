//
//  TrackerManager.swift
//  Task Tracker
//
//  Created by protel on 24.07.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

// Scroll to after struct's closing curly bracket to find more
struct TaskTrackerManager {
    
    let userDefStandard = UserDefaults.standard
    
    func checkIfFirstLaunchEver(){ //Is it the first launch ever?
        if UserDefaults.checkIfFirstLaunchEver() { // Is it the first time?
            userDefStandard.set(0, forKey: "lastGeneratedTaskID")
        }
    }
    
    // Add the new task to the memory
    func saveNewTask(newTask: Task){
        Task.addToCatalog(newTask)
        UserDefaults.saveTask(newTask)
    }
    
    // Get the tasks from memory on launch
    func bringSavedTasks(){
        //These lines are for bringing previously created Tasks back...
        guard let taskCount = userDefStandard.value(forKey: "lastGeneratedTaskID") as? Int else {
            return
        }
        for x in 0..<taskCount {
            let task = UserDefaults.getCompleteTask(withID: x+1)
            let action = (task == nil) ? {} : {Task.addToCatalog(task!)}
            action()
        }
    }

    // Update tasks from memory
    func refreshTasks() throws -> [Task]  {
        var tasks = [Task]()
        guard let count = userDefStandard.value(forKey: "lastGeneratedTaskID") as? Int else {
            throw TrackerError["Search for invalid key"]
        }
        for x in 0..<count {
            guard let taskID = userDefStandard.value(forKey: "taskID_\(x+1)") as? Int else {
                continue
            }
            guard let task = Task[taskID] else {
                continue
            }
            tasks.append(task)
        }
        
        if tasks.count == 0 {
            userDefStandard.set(0, forKey: "lastGeneratedTaskID")
        }
        
        return tasks
    }
}

typealias ContainsTableView = UITableViewDelegate & UITableViewDataSource

protocol NewTaskEntryDelegate {
    func didUserCreateNewTask(_ from: NewTaskCreatingViewController)
}

enum TrackerError: String, Error {
    case UnexpectedError = "Unexpected Error"
    case InvalidKey = "Search for invalid key"
    
    static subscript(raw: String) -> TrackerError{
        if let error = TrackerError(rawValue: raw) {
            return error
        }
        else {
            return TrackerError.UnexpectedError
        }
    }
}
