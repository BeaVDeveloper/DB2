//
//  DatabaseManager.swift
//  DB2
//
//  Created by Yura Velko on 7/12/19.
//  Copyright © 2019 Yura Velko. All rights reserved.
//

import Foundation
import SwiftyJSON

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    var privatBankData: [PrivatBank] = []
    var nbuData: [NBU] = []
    
    func clearData() {
        privatBankData = []
        nbuData = []
    }
    
    func fillDatabase(type: URLType, date: String = Date().formattedString()) {
        clearData()
        
        var isPrivatData: Bool?
        
        NotificationCenter.default.post(name: Globals.NotificationNames.StartLoadingData, object: nil, userInfo: ["isPrivatData": true])
        Service.shared.getCurrencyInfo(urlType: type, date: date) { (json) in
            if type == .URL_NOW {
                for i in 0..<json.count {
                    let currency = PrivatBank(name: json[i]["ccy"].stringValue, buyPrice: String(format: "%.3f", json[i]["buy"].doubleValue), sellPrice: String(format: "%.3f", json[i]["sale"].doubleValue))
                    self.privatBankData.append(currency)
                }
            } else {
                for curr in json["exchangeRate"].arrayValue {
                    
                    if let saleRate = curr["saleRate"].double {
                        let currency = PrivatBank(name: curr["currency"].stringValue, buyPrice: String(format: "%.3f", curr["purchaseRate"].doubleValue), sellPrice: String(format:  "%.3f", saleRate))
                        
                        if currency.name == "EUR" || currency.name == "USD" || currency.name == "RUB" {
                            self.privatBankData.insert(currency, at: 0)
                        } else {
                            self.privatBankData.append(currency)
                        }
                    }
                }
            }
            isPrivatData = true
            NotificationCenter.default.post(name: Globals.NotificationNames.UpdateTableData, object: nil, userInfo: ["isPrivatData": isPrivatData as Any])
        }
        NotificationCenter.default.post(name: Globals.NotificationNames.StartLoadingData, object: nil, userInfo: ["isPrivatData": false])
        Service.shared.getCurrencyInfo(urlType: type == .URL_NOW ? .URL_ON_DATE_NOW : type, date: date) { (json) in
            for curr in json["exchangeRate"].arrayValue {
                
                if let saleRate = curr["saleRateNB"].double {
                    let currency = NBU(name: Globals.rusNameDict[curr["currency"].stringValue] ?? "None", avgPrice: String(format: "%.2f", saleRate), oneCurrency: curr["currency"].stringValue)
                    
                    if currency.name != "None" {
                        self.nbuData.append(currency)
                    }
                }
            }
            isPrivatData = false
            NotificationCenter.default.post(name: Globals.NotificationNames.UpdateTableData, object: nil, userInfo: ["isPrivatData": isPrivatData as Any])
        }
    }
}

