//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Владимир Ладыгин on 11.06.2022.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    @IBOutlet weak var submitButton: UIBarButtonItem!
    
    // MARK: - Constants
    let cellManager = CellManager()
    let networkManager = NetworkManager()
    
    
    // MARK: - Stored Properties
    var minutes = 0
    private var orderToView: [[MenuItem]] = []
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "OrderConfirmationSegue" else { return }
        let destination = segue.destination as! OrderConfirmationViewController
        destination.minutes = minutes
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        OrderManager.shared.order = Order()
        
    }
    //MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkEditButton()
        
        
        //Added Edited Button
        navigationItem.setLeftBarButton(editButtonItem, animated: false)
        NotificationCenter.default.addObserver(
            tableView!,
            selector: #selector(UITableView.reloadData),
            name: OrderManager.orderUpdateNotification,
            object: nil
        )
        
    }
    
    // MARK: - UITableViewSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Hide Edit Button Edit and Submit, if OrderList is Empty.
        checkEditButton()
        viewOrderQuantities()
        
//        return OrderManager.shared.order.menuItems.count
        return orderToView.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
//        let menuItem = OrderManager.shared.order.menuItems[indexPath.row]
        //        cellManager.configure(cell, with: menuItem, for: tableView, indexPath: indexPath)
        let name = orderToView[indexPath.row].first!.name
        let price = orderToView[indexPath.row].first!.price
        let quantity = orderToView[indexPath.row].count
        cell.textLabel?.text = "\(name) x \(quantity)"
        cell.detailTextLabel?.text = (price * Double(quantity)).formattedHundreds
        return cell
    }
    
    // MARK: - Custom Methods
    func uploadOrder() {
        let menuIds = OrderManager.shared.order.menuItems.map { $0.id }
        networkManager.submitOrder(forMenuIDs: menuIds) { minutes, error in
            if let error = error {
                print(#line, #function, "ERROR: \(error.localizedDescription)")
            } else {
                guard let minutes = minutes else {
                    print(#line, #function, "ERROR: didn't get minutes from server")
                    return
                }
                self.minutes = minutes
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "OrderConfirmationSegue", sender: nil)
                }
            }
            
        }
        
    }
    
    func checkEditButton() {
        navigationItem.rightBarButtonItem?.isEnabled = OrderManager.shared.order.menuItems.count != 0 ? true : false
        navigationItem.leftBarButtonItem?.isEnabled = OrderManager.shared.order.menuItems.count != 0 ? true : false
    }
    
    private func viewOrderQuantities () {
        orderToView = Array(
            Dictionary(grouping: OrderManager.shared.order.menuItems) { $0.id }.values
        ).sorted(by: { $0.first!.name < $1.first!.name})
    }
    
    
    // MARK: - Actions
    
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        let orderTotal = OrderManager.shared.order.menuItems.reduce(0) { $0 + $1.price }
        
        let alert = UIAlertController(
            title: "Confirm order",
            message: "You are about to submit your order with a total of \(orderTotal.formattedHundreds)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Submit", style: .default) {_ in
            self.uploadOrder()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
}

extension OrderTableViewController /*: UITableViewDelegate */  {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            orderToView.remove(at: indexPath.row)
            OrderManager.shared.order.menuItems = orderToView.flatMap { $0 }
        case .insert:
            break
        case .none:
            break
        @unknown default:
            break
        }
        checkEditButton()
    }
    
}



