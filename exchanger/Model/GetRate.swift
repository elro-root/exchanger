//
//  Currency.swift
//  exchanger
//
//  Created by Patrik Duksin on 10.08.2021.
//

import Foundation

struct GetRate: Codable {
    var success: Bool
    var base: String
    var date: String
    var rates: [String: Float]
}
