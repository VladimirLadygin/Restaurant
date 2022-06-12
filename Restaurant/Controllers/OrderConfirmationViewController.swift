//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Владимир Ладыгин on 11.06.2022.
//

import UIKit

class OrderConfirmationViewController: UIViewController {

    @IBOutlet var timeRemainingLabel: UILabel!
    
    var minutes: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        timeRemainingLabel.text = "Thank you for your order! Your waiting time is approximately (\(minutes!) minutes."

    }
  
}
