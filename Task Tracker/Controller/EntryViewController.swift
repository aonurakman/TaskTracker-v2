//
//  EntryViewController.swift
//  Task Tracker
//
//  Created by protel on 23.07.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

extension UIViewController { // Required for keyboard dismiss on tap
    func dismissKey(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer (target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class EntryViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var bigStack: UIStackView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var nameField: UITextField!
    
    var delegate: EntryDelegate?
    var manager = Manager()
    
    var suggestedName: String? // Required for task updating process
    var suggestedNote: String?
    var suggestedDate: Date?
    var suggestedID: Int?
    var isForUpdating: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()
        adjustUI()
        if isForUpdating { // Are we here to update an existing task?
            datePicker.date = suggestedDate!
            notesField.text = suggestedNote!
            nameField.text = suggestedName!
        }
        nameField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
    @objc @IBAction func saveTask() { // Saving
        guard let text = nameField.text, !text.isEmpty else {
            nameField.placeholder = "This cannot be empty."
            nameField.isSelected = true
            return
        }
        var count: Int
        if isForUpdating {
            count = suggestedID!
            Task.catalog[count] = nil
        } else {
            count = UserDefaults().value(forKey: "count") as! Int + 1
        }
        
        manager.updateMemory(text: text, note: notesField.text ?? " ", date: datePicker.date, count: count)

        self.delegate?.didSendNewTask(self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickedCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //Should adapt to the phone orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        adjustUI()
    }
    
    func adjustUI(){
        if UIDevice.current.orientation.isLandscape {
            bigStack.axis = .horizontal
            bigStack.spacing = 30
        } else {
            bigStack.axis = .vertical
            bigStack.spacing = 15
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        notesField.selectAll(textField)
        return true
    }

}
