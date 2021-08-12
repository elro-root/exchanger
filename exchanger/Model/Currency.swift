//
//  CurrencyList.swift
//  exchanger
//
//  Created by Patrik Duksin on 10.08.2021.
//

import Foundation

struct Currency: Codable {
    var description: String?
//    like USD, EUR
    var code: String?
    var sell: Float?
}
