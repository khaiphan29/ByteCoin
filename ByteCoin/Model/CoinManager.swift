//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin (coinModel: CoinModel)
    func didOccurError (error: Error)
}

struct CoinManager {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "7A4F9316-BC74-436B-B184-62D67C2F8D20"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?

    func fetchRate(row index: Int) {
        let urlString = "\(baseURL)\(currencyArray[index])?apikey=\(apiKey)"
        performRequest(for: urlString)
    }
    
    private func performRequest(for urlString: String) {
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url!) { data, urlResponse, error in
            if error != nil {
                delegate?.didOccurError(error: error!)
                return
            }
            if let safeData = data {
                if let coinModel = parseJSON(data: safeData) {
                    delegate?.didUpdateCoin(coinModel: coinModel)
                }
            }
        }.resume()
    }
    
    private func parseJSON(data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(CoinData.self, from: data)
            return CoinModel(name: result.asset_id_quote, rate: result.rate)
        } catch {
            delegate?.didOccurError(error: error)
            return nil
        }
    }
}
