//
//  ViewController.swift
//  CoinApp
//
//  Created by 米倉謙 on 2020/09/13.
//  Copyright © 2020 kenyonekura.com. All rights reserved.
//

import UIKit
//PIckerViewを使用する時に必ず必要UIPickerViewDataSource→FIXで2つ関数を出現させる｡決まりごと｡
class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,CoinManagerDelegate {
    func didUpdatePrice(price: String,btc: String,currency: String) {
        
//        同期処理/非同期処理をしている｡詳しくはググる
        DispatchQueue.main.async {
//            コインラベルをテキストとして表示する
            self.coinLabel.text = price
//            仮想通貨の通貨単位を表示する
            self.BtcLabel.text = btc
//            currencyの値を表示
            self.currencyLabel.text = currency
//
        }
        
    }
//    エラー処理として必要
    func didFainalWithError(error: Error) {
        print("error")
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        Pickerの列を決める部分
//        通貨のみなので今回は1
        return 2
    }
    
    
//    CoinManeger.swift内の構造体(CoinManeger)から値を取ってくるために宣言する｡何事も取得するためには空の箱を用意する
    var coinManager = CoinManager()
    
//    Pickerに表示させるために取得する構文今回は上で取得してきたcoinManegerの中のcurrencyArrayを数分だけ持ってくる｡
//    ここでcountとは配列の要素数の事を表している｢numberOfRowsInComponent｣セルの数を決めている｡
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //        ピッカーの中に表示するもの
//        switch文のconponentの意味が分からない｡定数式の0とか1はもともとそういう意味なのか？
        switch component {
        case 0:
            return coinManager.btcArray.count
        case 1:
             return coinManager.currentArray.count
        default:
           return 0
        }
    }
    
//    PickerViewの出力をココでも司っている｡[row]とはExcelでいう行のこと｡セルに表示するラベルを確定させる｡
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return coinManager.btcArray[row]
        case 1:
            return coinManager.currentArray[row]
        default:
            return "error"
        }
        
    }
    
    
    
//    didSelectRowはピッカーで何が選択されたかを判別している｡ didSelectRow rowとはユーザーが出力した値はrowで出力されるよという意味
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        選択されたものが何かわかるようにするプリント
//        print(row,coinManager.currentArray[row])
//        print(row,coinManager.btcArray[row])
//
        
// 取ってきたい値を定数に格納する｡何か値を取得したいときは変数or定数で必ず宣言する｡今回は入れたいのはcoinManeger.currencyArray[row]
//        pickerViewの選択が分技する場合は[pickerView.selectedRow(inComponent: 0)]とする｡switchの定数式で指定した値を使うのだろうか？
        let selectedCurrency = coinManager.btcArray[pickerView.selectedRow(inComponent: 0)]
        let selectedCurrency2 =
        coinManager.currentArray[pickerView.selectedRow(inComponent: 1)]
        print(selectedCurrency)
        print(selectedCurrency2)
        
//        コインマネージャーの値をgetCoinPriceに送る(それはslectCurrency)の値
//        値渡しCoinManagerに格納されている値をgetCoinPriceに送る｡それはselectedCurrencyに格納された値です｡
        
        coinManager.getCoinPrice(currency: selectedCurrency2, btc: selectedCurrency)
        
        
//        ここでやっていることは､どの通貨が選択されているかを判別して､ユーザーが選択した通貨を元にデータを取得したいのでURLを生成しようとしている｡
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        PIckerのどのデータソースを使うのか宣言する構文｡viewDidLoad内に入れる決まりごと
        currencyPicker.dataSource = self
//        PIckerのどのデータソースを使うのか宣言する構文｡viewDidLoad内に入れる決まりごと(delegateを使いますという宣言)
        currencyPicker.delegate = self
        
        coinManager.delegate = self
        
    }

    //StackView内のラベル左側(コインの金額が出る)
    @IBOutlet var coinLabel: UILabel!
    //StackView内のラベル右側(通貨単位が出る)
    @IBOutlet var currencyLabel: UILabel!
    //    ピッカー
    @IBOutlet var currencyPicker: UIPickerView!
    
    @IBOutlet var BtcLabel: UILabel!
}
