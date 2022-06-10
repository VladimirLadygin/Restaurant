//
//  Order.swift
//  Restaurant
//
//  Created by Владимир Ладыгин on 11.06.2022.
//

import Foundation

struct Order {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []){
        self.menuItems = menuItems
    }
    
}
