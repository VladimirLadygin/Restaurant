//
//  PreparationTime.swift
//  Restaurant
//
//  Created by Владимир Ладыгин on 11.06.2022.
//


import Foundation

struct PreparationTime: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
