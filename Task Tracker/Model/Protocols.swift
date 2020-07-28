//
//  Protocols.swift
//  Task Tracker
//
//  Created by protel on 28.07.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit


protocol NewTaskEntryDelegate {
    func didUserCreateNewTask(_ from: NewEntryScreenViewController)
}

protocol ContainsTableView: UITableViewDelegate, UITableViewDataSource {
}

protocol AdaptsDeviceOrientation{
    func adjustUiElementsForDeviceOrientation()
}

protocol UsesDateInput{
    func createDatePickerKeyboardForDateInput()
}
