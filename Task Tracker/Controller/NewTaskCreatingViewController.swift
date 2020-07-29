//
//  EntryViewController.swift
//  Task Tracker
//
//  Created by protel on 23.07.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

protocol UsesDateInput{
    func createDatePickerKeyboardForDateInput()
}

protocol AdaptsDeviceOrientation{
    func adjustUiElementsForDeviceOrientation()
}

class NewTaskCreatingViewController: UIViewController {

    @IBOutlet weak var bigStack: UIStackView!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    var datePicker = UIDatePicker()
    
    var newTaskEntryDelegate: NewTaskEntryDelegate?
    var taskTrackerManager = TaskTrackerManager()
    
    var idForNewTask: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gestureCreator()
        createDatePickerKeyboardForDateInput()
        nameField.delegate = self
        adjustUiElementsForDeviceOrientation()
        
        isDataPassedFromMainView()
        timeField.text = datePicker.date.convertToString()
    }
    
    //The method that main view uses for displaying an existing task in this view
    func getIdOfTaskFromMainView(taskID: Int?, newTaskEntryDelegate: NewTaskEntryDelegate) {
        self.idForNewTask =
            taskID ?? UserDefaults().value(forKey: "lastGeneratedTaskID") as! Int + 1
        self.newTaskEntryDelegate = newTaskEntryDelegate
    }
    
    func isDataPassedFromMainView () { // Are we here to update an existing task?
        if let taskToDisplay = Task[idForNewTask] {
            datePicker.date = taskToDisplay.date
            notesField.text = taskToDisplay.notes
            nameField.text = taskToDisplay.name
            self.title = taskToDisplay.name
        }
    }
    
    @IBAction func saveClicked() { // Saving
        guard let taskName = nameField.text, !taskName.isEmpty else {
            nameField.placeholder = "This cannot be empty!"
            return
        }
        
        let generatedTask = Task(name: taskName, notes: notesField.text ?? " ", date: datePicker.date, id: idForNewTask)
        
        taskTrackerManager.saveNewTask(newTask: generatedTask)
        self.newTaskEntryDelegate?.didUserCreateNewTask(self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}


extension NewTaskCreatingViewController: AdaptsDeviceOrientation {
    //Should adapt to the phone orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        adjustUiElementsForDeviceOrientation()
    }

    func adjustUiElementsForDeviceOrientation(){
        if UIDevice.current.orientation.isLandscape {
            bigStack.axis = .horizontal
            bigStack.spacing = 30
        } else {
            bigStack.axis = .vertical
            bigStack.spacing = 15
        }
    }
}

extension NewTaskCreatingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        notesField.selectAll(textField)
        return true
    }
}

extension NewTaskCreatingViewController: UsesDateInput {
    //Enables us to use datepicker keyboard for date input
    func createDatePickerKeyboardForDateInput() {
        datePicker.date = Date()
        datePicker.datePickerMode = .dateAndTime
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneActionCreator))
        toolbar.setItems([doneButton], animated: true)
        
        timeField.inputAccessoryView = toolbar
        timeField.inputView = datePicker
    }
    
    @objc func doneActionCreator(){
        timeField.text = datePicker.date.convertToString()
        self.view.endEditing(true)
    }
}
