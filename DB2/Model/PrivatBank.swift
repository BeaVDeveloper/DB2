//
//  PrivatBank.swift
//  DB2
//
//  Created by Yura Velko on 7/12/19.
//  Copyright © 2019 Yura Velko. All rights reserved.
//

struct PrivatBank {
    private(set) var name: String
    private(set) var buyPrice: String
    private(set) var sellPrice: String
    
    init(name: String, buyPrice: String, sellPrice: String) {
        
        self.name = name == "RUR" ? "RUB" : name
        self.buyPrice = buyPrice
        self.sellPrice = sellPrice
    }
}
