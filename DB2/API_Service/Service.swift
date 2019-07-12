//
//  Service.swift
//  DB2
//
//  Created by Yura Velko on 7/12/19.
//  Copyright © 2019 Yura Velko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum URLType {
    case URL_ON_DATE, URL_NOW, URL_ON_DATE_NOW
}

class Service {
    
    private let URL_ON_DATE = "https://api.privatbank.ua/p24api/exchange_rates?json&date="
    private let URL_NOW = "https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5"
    
    static let shared = Service()
    
    func getCurrencyInfo(urlType: URLType, date: String, completion: @escaping (JSON) -> ()) {
        var url = ""
        switch urlType {
        case .URL_NOW:
            url = URL_NOW
        case .URL_ON_DATE_NOW:
            url = URL_ON_DATE + Date().formattedString()
        default:
            url = URL_ON_DATE + date
        }
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let currencyJSON = JSON(response.result.value!)
                completion(currencyJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
}
