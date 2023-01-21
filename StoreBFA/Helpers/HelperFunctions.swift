//
//  HelperFunctions.swift
//  StoreBFA
//
//  Created by Furkan Akman on 17.01.2023.
//

import Foundation
func convertToCurrency(_ number: Double) -> String {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency


    let priceString = currencyFormatter.string(from: NSNumber(value: number))!
    
    return priceString
}
