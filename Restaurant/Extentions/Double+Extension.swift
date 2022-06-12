//
//  Double+Extension.swift
//  Restaurant
//
//  Created by Владимир Ладыгин on 11.06.2022.
//

import Foundation

extension Double {
    var formattedHundreds: String {
       return String(format: "$%.2f", self)
    }
}
