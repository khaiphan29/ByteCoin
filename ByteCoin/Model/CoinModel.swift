//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Phan Khai on 31/05/2022.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation
struct CoinModel {
    let name: String
    let rate: Double
    var rateString: String {
        return String(format: "%.2f", rate)
    }
}
