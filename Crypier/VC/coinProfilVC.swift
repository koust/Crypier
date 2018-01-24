//
//  coinProfilVC.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 9.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import UIKit
import FSLineChart
import Kingfisher
import DefaultsKit
import LLSpinner
import CDAlertView
import SwiftyTimer

class coinProfilVC: UIViewController,UITableViewDataSource {

    @IBOutlet weak var pageView: UITableView!
    @IBOutlet weak var coinChart: FSLineChart!
    @IBOutlet weak var pageCoinImage: UIImageView!
    var followShortName:[String] = []
    var followWalletName:[String] = []
    var followWalletCoin:[Double] = []
    
    //For Shared Prefences
    let defaults = Defaults()
    let key = Key<[String]>("followList")
    
    let walletNamekey = Key<[String]>("walletNamekey")
    let walletCoinkey = Key<[Double]>("walletCoinkey")
    
    var coin:String = ""
    var coinLong:String = ""
    var data: [Double] = []
    var timeChart: [String] = []
    var tableViewData : [String] = []
    var tableViewDataTitle : [String] = [NSLocalizedString("coinname", comment: ""),
                                         NSLocalizedString("marketcap", comment: ""),
                                         NSLocalizedString("dollarprice", comment: ""),
                                         NSLocalizedString("cap24hrChange", comment: ""),
                                         NSLocalizedString("vwap_h24", comment: ""),
                                         NSLocalizedString("europrice", comment: ""),
                                         NSLocalizedString("bitcoinprice", comment: ""),
                                         NSLocalizedString("etherumprice", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LLSpinner.spin()

        let url = URL(string: "http://www.coincap.io/images/coins/\(coinLong).png")
        pageCoinImage.kf.setImage(with: url)
        
        // For Graph
 
        RouterUtility.shared.history(coin: coin, callback: {response in
            if !response.hasError {
                var count = 0;
                for index in 0...response.data.price.count-1 {
                    
                    let date = Date()
                    let strDate = date.string(with: response.data.price[index][0].stringValue)
                    
                    self.data.append((response.data.price[index][1]).doubleValue)
                    
                    self.timeChart.append(strDate)
                    
                    
                    
                }
                
                //                self.timeChart = Array(self.timeChart.suffix(10))
                //                print(self.timeChart)
                self.data.append((response.data.price[response.data.price.count-1][1]).doubleValue)
                let date2 = Date()
                let strDate2 = date2.string(with: response.data.price[response.data.price.count-1][0].stringValue)
                self.timeChart.append(strDate2)
                print(self.data)
                self.load()
            }
            
        })
        
  
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        
        followShortName = defaults.get(for: key) ?? [""]
        followWalletName = defaults.get(for: walletNamekey) ?? [""]
        followWalletCoin = defaults.get(for: walletCoinkey) ?? [0.0]
        
        Router.doviz = 0
        self.coinProfildata()
     
        homeVC.analyticsScreen(nameVC: "\(coinLong)-VC")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pageView.dequeueReusableCell(withIdentifier: "coinPage") as! coinPageCell
        
        
        cell.label1.text = tableViewDataTitle[indexPath.row]
        cell.label2.text = tableViewData[indexPath.row]
        
        if(indexPath.row == 3){
            
            cell.label2.text =  tableViewData[indexPath.row] + "%"
            let string = tableViewData[indexPath.row]
            let needle: Character = "-"
            if string.characters.index(of: needle) != nil {
                cell.label2.textColor = UIColor.red
            }else if string == "0" {
                cell.label2.textColor = UIColor.orange
            }else {
                cell.label2.textColor = UIColor.green
            }
        }else if(indexPath.row == 2){
            
            cell.label2.text =  "$" + tableViewData[indexPath.row]
        }else if(indexPath.row == 5){
            
            cell.label2.text =  "€" + tableViewData[indexPath.row]
        }else if(indexPath.row == 1){
            
            cell.label2.text =  "$" + tableViewData[indexPath.row]
        }
        
        
        
        return cell
    }
    
    @IBAction func addList(_ sender: Any) {
        let alert =  CDAlertView(title:NSLocalizedString("addlisttitle", comment: ""), message: NSLocalizedString("addlistdesc", comment: ""), type:.notification )
        
        let cancel = CDAlertViewAction(title: NSLocalizedString("cancel", comment: ""),handler: { action in
           
        })
        
        let alist = CDAlertViewAction(title: NSLocalizedString("alist", comment: ""),handler: { action in
            
            self.addtoList()
            
            
        })
        
        let awallet = CDAlertViewAction(title: NSLocalizedString("awallet", comment: ""),handler: { action in
            
            self.addtoWallet()
        })
        
   
        alert.add(action: alist)
        alert.add(action: awallet)
        alert.add(action: cancel)
    
    
    alert.show();

    }
    
    
    public func load() {
        
        coinChart.backgroundColor = UIColor.clear
        coinChart.valueLabelTextColor = UIColor.white
        coinChart.valueLabelBackgroundColor = UIColor.clear
        coinChart.axisWidth = self.coinChart.frame.width-10
        //coinChart.margin = 25
        
        coinChart.verticalGridStep = 7
        coinChart.horizontalGridStep = 6
        coinChart.labelForIndex = { index in
            return self.timeChart[Int(index)]
            
        }
        coinChart.labelForValue = { "$\($0)" }
        coinChart.setChartData(data)
    }
    
    
    func addtoWallet(){
        //1. Create the alert controller.
        let alert = UIAlertController(title: NSLocalizedString("awallet", comment: ""), message: NSLocalizedString("awalletdesc", comment: ""), preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            textField.placeholder =  NSLocalizedString("awalletplace", comment: "")
            if  self.followWalletName.contains(self.coin){
                if let i = self.followWalletName.index(of: self.coin) {
                    textField.text = String(self.followWalletCoin[i])
                    
                }
            }
        }
        
        alert.addAction(UIAlertAction(title:NSLocalizedString("cancel", comment: ""),style:.cancel,handler:{ [weak alert] (_) in
            
            
        }))
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: NSLocalizedString("add", comment: ""), style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
      
            let todouble =  Double((textField?.text as! String).replacingOccurrences(of: ",", with: "."))
         
            if  self.followWalletName.contains(self.coin){
                if let i = self.followWalletName.index(of: self.coin) {
                    self.followWalletCoin[i] = todouble!
                    self.defaults.set(self.followWalletCoin,for:self.walletCoinkey)
                    
                    coinSearchVC.showAlert(text:NSLocalizedString("editnotifi", comment: ""),theme: .success)
                }
            }else{
            self.followWalletName.append(self.coin)
            self.followWalletCoin.append(todouble!)
            self.defaults.set(self.followWalletCoin,for:self.walletCoinkey)
            self.defaults.set(self.followWalletName,for:self.walletNamekey)
                
                coinSearchVC.showAlert(text:NSLocalizedString("sucessnotifi", comment: ""),theme: .success)
            }
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func addtoList(){
        if self.followShortName.contains(self.coin) {
            
            coinSearchVC.showAlert(text:NSLocalizedString("warningnotifi", comment: ""),theme: .warning)
        }else{
            self.followShortName.append(self.coin)
            self.defaults.set(self.followShortName,for:self.key)
            coinSearchVC.showAlert(text:NSLocalizedString("sucessnotifi", comment: ""),theme: .success)
            
        }

    }

    
    func coinProfildata(){
        RouterUtility.shared.coinPage(coin: coin, callback: {response in
            
            if !response.hasError {
                
                self.tableViewData.append(response.data.display_name)
                self.tableViewData.append(String(response.data.market_cap))
                self.tableViewData.append(String(response.data.price))
                self.tableViewData.append(String(response.data.cap24hrChange))
                self.tableViewData.append(String(response.data.vwap_h24))
                self.tableViewData.append(String(response.data.price_eur))
                self.tableViewData.append(String(response.data.price_btc))
                self.tableViewData.append(String(response.data.price_eth))
                
                
                self.navigationController?.navigationBar.topItem?.title = response.data.display_name
                
                self.pageView.reloadData()
                
            }
            
        })
    }
}
