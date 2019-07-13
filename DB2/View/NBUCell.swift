//
//  NBUCell.swift
//  DB2
//
//  Created by Yura Velko on 7/12/19.
//  Copyright © 2019 Yura Velko. All rights reserved.
//

import UIKit

class NBUCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var oneCurrency: UILabel!
    @IBOutlet weak var avgPrice: UILabel!
    
    
    func setNBUCurrency(curr: NBU) {
        name.text = curr.name
        avgPrice.text = curr.avgPrice + "UAH"
        oneCurrency.text = "1" + curr.baseCurrency
    }
}
