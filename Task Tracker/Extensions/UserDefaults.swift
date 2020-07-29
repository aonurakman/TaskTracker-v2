//
//  UserDefaults Memory Management Extensions.swift
//  Task Tracker
//
//  Created by protel on 29.07.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import Foundation

extension UserDefaults {
    static func saveTask(_ newTask: Task) {
        UserDefaults().set((UserDefaults().value(forKey: "lastGeneratedTaskID") as! Int + 1), forKey: "lastGeneratedTaskID")
        UserDefaults().set(newTask.id, forKey: "taskID_\(newTask.id)")
        UserDefaults().set(newTask.name, forKey: "taskName_\(newTask.id)")
        UserDefaults().set(newTask.date, forKey: "taskDate_\(newTask.id)")
        UserDefaults().set(newTask.notes, forKey: "taskNote_\(newTask.id)")
    }
    
    static func getCompleteTask(withID: Int) -> Task? {
        guard let id = UserDefaults().value(forKey: "taskID_\(withID)") as? Int else {
            return nil
        }
        guard let name = UserDefaults().value(forKey: "taskName_\(withID)") as? String else {
            return nil
        }
        guard let notes = UserDefaults().value(forKey: "taskNote_\(withID)") as? String else {
            return nil
        }
        guard let date = UserDefaults().value(forKey: "taskDate_\(withID)") as? Date else {
            return nil
        }
        
        return Task(name: name, notes: notes, date: date, id: id)
    }
}

extension UserDefaults {
    static func checkIfFirstLaunchEver() -> Bool {
        if !UserDefaults().bool(forKey: "firstLaunchEver"){
            UserDefaults().set(true, forKey: "firstLaunchEver")
            return true
        }
        return false
    }
}

extension UserDefaults {
    static func deleteTask(id: Int) {
        UserDefaults().set(nil , forKey: "taskID_\(id)")
    }
}
