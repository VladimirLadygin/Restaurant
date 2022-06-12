//
//  OrderManager.swift
//  Restaurant
//
//  Created by Владимир Ладыгин on 11.06.2022.
//

import Foundation

class OrderManager {
    static let orderUpdateNotification = Notification.Name("OrderManager.orderUpdated")
    
    static var shared = OrderManager()
    
    private init() {}
    
    var order = Order() {
        didSet {
        NotificationCenter.default.post(name: OrderManager.orderUpdateNotification, object: nil)
        }
            
    }
}
