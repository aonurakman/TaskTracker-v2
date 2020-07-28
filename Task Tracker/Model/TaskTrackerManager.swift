//
//  TrackerManager.swift
//  Task Tracker
//
//  Created by protel on 24.07.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

struct TaskTrackerManager{
    
    func checkIfItIsTheFirstLaunchEver(){ //Is it the first launch ever?
        if !UserDefaults().bool(forKey: "firstLaunchEver") { // Is it the first time?
            UserDefaults().set(true, forKey: "firstLaunchEver")
            UserDefaults().set(0, forKey: "count")
        }
    }
    
    // Add the new task to the memory
    func addNewTaskToTheMemory(name: String, note: String, date: Date, count: Int){
        let newTask = Task(name: name, notes: note, date: date, id: count)
        Task.addToCatalog(newTask)
        
        UserDefaults().set((UserDefaults().value(forKey: "count") as! Int + 1), forKey: "count")
        UserDefaults().set(newTask.id, forKey: "taskID_\(count)")
        UserDefaults().set(newTask.name, forKey: "taskName_\(count)")
        UserDefaults().set(newTask.date, forKey: "taskDate_\(count)")
        UserDefaults().set(newTask.notes, forKey: "taskNote_\(count)")
    }
    
    // Get the tasks from memory on launch
    func bringSavedTasksFromMemory(){
        //These lines are for bringing previously created Tasks back...
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        for x in 0..<count {
            guard let id = UserDefaults().value(forKey: "taskID_\(x+1)") as? Int else {
                continue
            }
            guard let name = UserDefaults().value(forKey: "taskName_\(x+1)") as? String else {
                continue
            }
            guard let notes = UserDefaults().value(forKey: "taskNote_\(x+1)") as? String else {
                continue
            }
            guard let date = UserDefaults().value(forKey: "taskDate_\(x+1)") as? Date else {
                continue
            }
            Task.addToCatalog(Task(name: name, notes: notes, date: date, id: id)) //adds to the catalog
        }
    }

    // Update tasks from memory
    func refreshTasks() throws -> [Task]  {
        var tasks = [Task]()
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            throw TrackerError["Search for invalid key"]
        }
        for x in 0..<count {
            guard let taskID = UserDefaults().value(forKey: "taskID_\(x+1)") as? Int else {
                continue
            }
            guard let task = Task[taskID] else {
                continue
            }
            tasks.append(task)
        }
        
        if tasks.count == 0 {
            UserDefaults().set(0, forKey: "count")
        }
        
        return tasks
    }
    
    func convertDateToString(format date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM E, HH:mm"
        return formatter.string(from: date)
    }
    
    func convertStringtoDate(format str: String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM E, HH:mm"
        return formatter.date(from: str) ?? Date()
    }
    
    func hasThisDatePassed(_ date: Date) -> Bool {
        return Date() >= date
    }

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
