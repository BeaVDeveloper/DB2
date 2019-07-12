//
//  Globals.swift
//  DB2
//
//  Created by Yura Velko on 7/12/19.
//  Copyright © 2019 Yura Velko. All rights reserved.
//

import Foundation

extension Date {
    private static let dateFormatter = DateFormatter()
    
    func formattedString() -> String {
        Date.dateFormatter.dateFormat = "dd.MM.YYYY"
        return Date.dateFormatter.string(from: self)
    }
}

struct Globals {
    static let rusNameDict = [
        "AUD": "Австралийский Доллар",
        "USD": "Доллар США",
        "RUB": "Росийский Рубль",
        "EUR": "Евро",
        "JPY": "Японская Иена",
        "CHF": "Швейцарский Франк",
        "GBP": "Британский Фунт",
        "PLZ": "Польский Злотый",
        "SEK": "Шведская Крона",
        "CAD": "Канадский Доллар",
        "CZK": "Чешская Крона",
        "DKK": "Датская Крона",
        "ILS": "Новый Израильский Шекель",
        "KZT": "Казахстанский Тенге",
        "NOK": "Норвежская Крона",
        "TMT": "Туркменский Манат",
        "TRY": "Турецкая Лира",
        "CNY": "Китайский Юань",
        "HUF": "Венгерский Форинт",
        "MLD": "Молдавский Лей",
        "SGD": "Сингапурский Доллар",
        "BYN": "Белорусский Рубль",
        "AZN": "Азербайджанский Манат",
        "GEL": "Грузинский Лари",
    ]
    
    struct NotificationNames {
        static let UpdateTableData = Notification.Name("UpdatePrivatData")
        static let StartLoadingData = Notification.Name("StartLoadingData")
    }
    
    struct CellIdentifier {
        static let privatBankCell = "privatBankCell"
        static let nbuCell = "nbuCell"
    }
}

