//
//  AnimateTable.swift
//  Auto Plurk
//
//  Created by 乾太 on 2017/2/20.
//  Copyright © 2017年 乾太. All rights reserved.
//

import Foundation
import UIKit

class AnimateTable {

    private var originalRow: Int
    private var tableView: UITableView
    
    init(originalRow: Int, tableView: UITableView) {
        self.originalRow = originalRow
        self.tableView = tableView
        self.animateTable()
    }

    private func animateTable() {
        self.tableView.reloadData()
        
        let cells = self.tableView.visibleCells
        let tableHeight: CGFloat = self.tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            if index >= self.originalRow {
                let cell: UITableViewCell = a as UITableViewCell
                UIView.animate(
                    withDuration: 1.5,
                    delay: 0.05 * Double(index),
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 0,
                    animations: {
                        cell.transform = CGAffineTransform(translationX: 0, y: 0);
                },
                    completion: nil
                )
            } else {
                let cell: UITableViewCell = a as UITableViewCell
                UIView.animate(
                    withDuration: 0,
                    delay: 0,
                    usingSpringWithDamping: 0,
                    initialSpringVelocity: 0,
                    animations: {
                        cell.transform = CGAffineTransform(translationX: 0, y: 0);
                },
                    completion: nil
                )
            }
            index += 1
        }
    }
}
