//
//  NBU.swift
//  DB2
//
//  Created by Yura Velko on 7/12/19.
//  Copyright © 2019 Yura Velko. All rights reserved.
//

import Foundation

class NBU {
    private(set) var name: String
    private(set) var avgPrice: String
    private(set) var oneCurrency: String
    
    init(name: String, avgPrice: String, oneCurrency: String) {
        self.name = name
        self.avgPrice = avgPrice
        self.oneCurrency = oneCurrency
    }
}
