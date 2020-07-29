//
//  UIVC Extension - KeyboardDismissOnTap.swift
//  Task Tracker
//
//  Created by protel on 29.07.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

extension UIViewController { // Required for keyboard dismiss on tap
    func gestureCreator(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer (target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
