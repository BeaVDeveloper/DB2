//
//  PrivatBankCell.swift
//  DB2
//
//  Created by Yura Velko on 7/12/19.
//  Copyright © 2019 Yura Velko. All rights reserved.
//


import UIKit

class PrivatBankCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var buyPrice: UILabel!
    @IBOutlet weak var sellPrice: UILabel!
    
    func setPrivatBankCurrency(curr: PrivatBank) {
        name.text = curr.name
        if let buy = Double(curr.buyPrice), buy > 1000.0, let sell = Double(curr.sellPrice), sell > 1000.0 {
            buyPrice.text = String(format: "%.1fK $", buy / 1000.0)
            sellPrice.text = String(format: "%.1fK $", sell / 1000.0)
        } else {
            buyPrice.text = curr.buyPrice
            sellPrice.text = curr.sellPrice
        }
    }
}

