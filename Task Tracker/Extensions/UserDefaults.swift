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
        let userDefStandard = UserDefaults.standard
        userDefStandard.set((UserDefaults().value(forKey: "lastGeneratedTaskID") as! Int + 1), forKey: "lastGeneratedTaskID")
        userDefStandard.set(newTask.id, forKey: "taskID_\(newTask.id)")
        userDefStandard.set(newTask.name, forKey: "taskName_\(newTask.id)")
        userDefStandard.set(newTask.date, forKey: "taskDate_\(newTask.id)")
        userDefStandard.set(newTask.notes, forKey: "taskNote_\(newTask.id)")
    }
    
    static func getCompleteTask(withID: Int) -> Task? {
        let userDefStandard = UserDefaults.standard
        guard let id = userDefStandard.value(forKey: "taskID_\(withID)") as? Int else {
            return nil
        }
        guard let name = userDefStandard.value(forKey: "taskName_\(withID)") as? String else {
            return nil
        }
        guard let notes = userDefStandard.value(forKey: "taskNote_\(withID)") as? String else {
            return nil
        }
        guard let date = userDefStandard.value(forKey: "taskDate_\(withID)") as? Date else {
            return nil
        }
        
        return Task(name: name, notes: notes, date: date, id: id)
    }
}

extension UserDefaults {
    static func checkIfFirstLaunchEver() -> Bool {
        let userDefStandard = UserDefaults.standard
        if !userDefStandard.bool(forKey: "firstLaunchEver"){
            userDefStandard.set(true, forKey: "firstLaunchEver")
            return true
        }
        return false
    }
}

extension UserDefaults {
    static func deleteTask(id: Int) {
        UserDefaults.standard.set(nil , forKey: "taskID_\(id)")
    }
}
