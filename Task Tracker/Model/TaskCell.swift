//
//  TaskCell.swift
//  Task Tracker
//
//  Created by protel on 29.07.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import UIKit

class TaskCell {
    let text: String
    let textColor: UIColor
    let textShadowOffset: CGSize
    let textShadowColor: UIColor
    let textFont: UIFont
    let detailText: String
    let bgColor: UIColor
    let dateOfElement: Date
    let indexPath: IndexPath
    let tableView: UITableView
    var detailTextColor: UIColor {
        get {
            dateOfElement.compareToCurrentTime() ? .red : .white
        }
    }
    
    
    init(text: String, textColor: UIColor, textShadowOffset: CGSize, textShadowColor: UIColor, textFont: UIFont, detailText: String, bgColor: UIColor, dateOfElement: Date, indexPath: IndexPath, tableView : UITableView) {
        self.text = text
        self.textColor = textColor
        self.textShadowOffset = textShadowOffset
        self.textShadowColor = textShadowColor
        self.textFont = textFont
        self.detailText = detailText
        self.bgColor = bgColor
        self.dateOfElement = dateOfElement
        self.indexPath = indexPath
        self.tableView = tableView
    }
    
    func getTableViewCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = text
        cell.backgroundColor = bgColor
        cell.textLabel?.textColor = textColor
        cell.textLabel?.shadowOffset = textShadowOffset
        cell.textLabel?.shadowColor = textShadowColor
        cell.textLabel?.font = textFont
        cell.detailTextLabel?.text = detailText
        cell.detailTextLabel?.textColor = detailTextColor
        return cell
    }
}

