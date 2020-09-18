//
//  CoinManager.swift
//  CoinApp
//
//  Created by 米倉謙 on 2020/09/13.
//  Copyright © 2020 kenyonekura.com. All rights reserved.
//

import Foundation
//プロトコルは設計図の仕様を定めた仕様書
//        ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
protocol CoinManagerDelegate {
    func didUpdatePrice(price: String,btc: String,currency: String)
    func didFainalWithError(error: Error)
}
//        ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
//??????????????????????????????????????????????????????????????????????????????????????????????????
// APIを取得するためのURLでcurrencyArrayを変更する事によって各国の通貨情報を取得する事ができる｡
struct CoinManager {
//    通過の単位はピッカーで変更する
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "B64B9BFD-3263-4DAC-8148-5B1627E5ECCB"
    let currentArray = ["USD","CNY","EUR","JPY","HKD"]
    let btcArray = ["BTC","BCH","ETH","XRP","XEM"]
    
//    プロトコルを使用するための変数
    var delegate:CoinManagerDelegate?
//    ==================================================================================================
//    forの中身は引数かパラメータ｡今回はStirng型でselectCurrencyから通貨の値を取得してきている
    func getCoinPrice(currency: String,btc: String){
//        ここで表示されるのはselectCurrencyからgetCoinPriceに引数として取得した通貨が表示される
//        print(currency)
//        URL生成
        print(btc)
        let urlString = "\(baseURL)/\(btc)/\(currency)/?apikey=\(apiKey)"
        print(urlString)
//        print(urlString)
//        ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
//        正しくURLが生成されていたら､urlStringセッションが呼び出されていた発動する｡
//        configurationはURLSessionの設定を提供するクラス｡今回はデフォルトを使用するという意味
//        Appleの公式ドキュメントにどう使うか記載されている

        if let url = URL(string: urlString) {
//            これは､URLSessionのdataTask(標準装備)にアクセスしていろいろできる｡小さい値はここでやりとりする｡
            let session = URLSession(configuration: .default)
//            URLSessionのdataTaskにアクセスするためのものdataTaskは標準装備
            let task = session.dataTask(with: url){
                (data,response,error)in
//                エラー処理
                if error != nil{
                    self.delegate?.didFainalWithError(error: error!)
                    return
                }
                if let safeData = data {
//                    parseJSONの値を取得してくる構文
                    if let bitcoinPrice = self.parseJSON(safeData) {
//                        出力する値のフォーマットを決めている今回は小数点以下2位まで｡bitcoinPriceはパーサーJSON値から取得
                        let priceString = String(format: "%.2f", bitcoinPrice)
//      取得した値はプロトコルで作っていたdidUpdatePriceへ返す｡priceString:仮想通貨の通貨換算の値｡btc:仮想通貨｡currency:JPYとユーロ
                        self.delegate?.didUpdatePrice(price: priceString, btc: btc, currency: currency)
                    }
                }
            }
//            タスク処理を開始させる構文
            task.resume()
        }
    }
//        ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
//        JSONの解析用に定義
    func parseJSON(_ data: Data) -> Double? {
        
//        JSONDecoderはJSONの解析のためには必ず必要
        let decoder = JSONDecoder()
//            decode=解析をする､アクセスするのはCoinDataのselfの中身
        do {
//            CoinDataという構造体にアクセス｡DecodeDataのrateのデータを取ってくる
            let decodeData = try decoder.decode(CoinData.self, from: data)
//                lastPriceにrateから取ってきたデータを格納
            let lastPrice = decodeData.rate
            print(lastPrice)
            return lastPrice
        } catch {
//                エラー処理､アクセスして値が返ってこない場合にアプリが落ちないようにしている｡エラー処理にdoCAtchを使用する
//                ここは予めエラーを投げておく→エラーで戻ってきたらcatchが発動する仕組み
//            アプリのエラー落ちはココで回避している
            delegate?.didFainalWithError(error: error)
            return nil
        }
    }
//        ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
//     ==================================================================================================
}
//??????????????????????????????????????????????????????????????????????????????????????????????????
