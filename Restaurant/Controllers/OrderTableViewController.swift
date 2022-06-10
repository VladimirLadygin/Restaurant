//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Владимир Ладыгин on 11.06.2022.
//

import UIKit

class OrderTableViewController: UITableViewController {
    // MARK: - Constants
    let cellManager = CellManager()

    // MARK: - STORED PROPERTIES
var order = Order()
    
    // MARK: - UITableViewSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        let menuItem = order.menuItems[indexPath.row]
        cellManager.configure(cell, with: menuItem, for: tableView, indexPath: indexPath)
        return cell
    }
    
    
}
