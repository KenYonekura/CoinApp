//
//  ViewController.swift
//  CoinApp
//
//  Created by 米倉謙 on 2020/09/13.
//  Copyright © 2020 kenyonekura.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String) {
        
//        同期処理/非同期処理をしている｡詳しくはググる
        DispatchQueue.main.async {
            
            self.coinLabel.text = price
            self.currencyLabel.text = currency
        }
        
    }
    
    func didFainalWithError(error: Error) {
        print("error")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        通貨のみなので今回は1
        return 1
    }
    
    
//    変数(coinManager)に構造体(CoinManager)←CoinManager.swiftの値を格納
    var coinManager = CoinManager()
    
//    ピッカービューのCellの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        ピッカーの中に表示するもの
        
        return coinManager.currentArray.count
        
    }
    
//    Cellに表示するラベル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return coinManager.currentArray[row]
        
    }
    
    
    
//    選択されたピッカーの値を取得(何をユーザーが選んでいるのかわかるところ)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        取得確認
        print(row,coinManager.currentArray[row])
        
//        入れる
        
        
        let selectedCurrency = coinManager.currentArray[row]
        
        
//        コインマネージャーに送る
//        値渡しCoinManagerに格納されている値をgetCoinPriceに送る｡それはselectedCurrencyに格納された値です｡
        coinManager.getCoinPrice(for: selectedCurrency)
        
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }

    
    @IBOutlet var coinLabel: UILabel!
    
    @IBOutlet var currencyLabel: UILabel!
    
    @IBOutlet var currencyPicker: UIPickerView!
}

