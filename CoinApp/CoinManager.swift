//
//  CoinManager.swift
//  CoinApp
//
//  Created by 米倉謙 on 2020/09/13.
//  Copyright © 2020 kenyonekura.com. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String,currency: String)
    func didFainalWithError(error: Error)
}

struct CoinManager {
//    通過の単位はピッカーで変更する
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "B64B9BFD-3263-4DAC-8148-5B1627E5ECCB"
    let currentArray = ["USD","CNY","EUR","JPY","HKD"]
    
//    設定したプロトコルを持ってくる｡delegateという型を指定している｡
    var delegate:CoinManagerDelegate?
    
    func getCoinPrice(for currency:String){
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        print(urlString)
        
//        urlStringが正しく認識していたら､UALSessionを使えるようにしている
        if let url = URL(string: urlString) {
//            クッキーとかキャッシュとかを(configuration: .default)←標準装備､で設定している
            let session = URLSession(configuration: .default)
//            URLSessionのdataTaskにアクセスするためのものdataTaskは標準装備
            let task = session.dataTask(with: url){
                (data,response,error)in
                if error != nil{
                    self.delegate?.didFainalWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ data: Data) -> Double? {
        
//        JSONDecoderはJSONの解析のためには必ず必要
        let decoder = JSONDecoder()
        
        do {
//            CoinDataという構造体にアクセス｡DecodeDataのrateのデータを取ってくる
            let decodeData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodeData.rate
            print(lastPrice)
            return lastPrice
        } catch {
//            アプリのエラー落ちはココで回避している
            delegate?.didFainalWithError(error: error)
            return nil
        }
    }

}
