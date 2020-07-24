//
//  TrackerManager.swift
//  Task Tracker
//
//  Created by protel on 24.07.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import Foundation


protocol EntryDelegate {
    func didSendNewTask(_ from: EntryViewController)
}


struct Manager{
    
    func checkIfFirstTime(){ //Is it the first launch ever?
        if !UserDefaults().bool(forKey: "setup") { // Is it the first time? Let's set up!
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
    }
    
    
    // Add the new task to the memory
    func updateMemory(text: String, note: String, date: Date, count: Int){
        let newTask = Task(name: text, notes: note, date: date, id: count)
        
        UserDefaults().set((UserDefaults().value(forKey: "count") as! Int + 1), forKey: "count")
        UserDefaults().set(newTask.id, forKey: "taskID_\(count)")
        UserDefaults().set(newTask.name, forKey: "taskName_\(count)")
        UserDefaults().set(newTask.date, forKey: "taskDate_\(count)")
        UserDefaults().set(newTask.notes, forKey: "taskNote_\(count)")
    }
    
    // Get the tasks from memory on launch
    func getFromMemory(){
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
            _ = Task(name: name, notes: notes, date: date, id: id) //adds to catalog
        }
    }
    
    
    func dateFormatter(format date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM E, HH:mm"
        return formatter.string(from: date)
    }
    
    func isItPassed(_ date: Date) -> Bool {
        return Date() >= date
    }
    
    // Update tasks from memory
    func refreshTasks() -> [Task]? {
        var tasks: [Task] = []
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return nil
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

}
