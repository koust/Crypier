//
//  walletVC.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 19.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import UIKit
import DefaultsKit
import LLSpinner
import SwiftyTimer
import Kingfisher

class walletVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var walletView: UITableView!
    
    var homeCoinData:[Coin] = []
    //var walletCoinData:[Double] = [0.00419952,0.00419952,0.00419952,0.00419952,0.00419952]
    
    var followWalletName:[String] = []
    var followWalletCoin:[Double] = []
    var kurlar:Kurlar?
    //For Shared Prefences
    let defaults = Defaults()
    
    let walletNamekey = Key<[String]>("walletNamekey")
    let walletCoinkey = Key<[Double]>("walletCoinkey")
    
    override func viewDidLoad() {
        super.viewDidLoad()
            LLSpinner.spin()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        followWalletName = defaults.get(for: walletNamekey) ?? [""]
        followWalletCoin = defaults.get(for: walletCoinkey) ?? [0]
        print(followWalletName)
        print(followWalletCoin)
    
        
   
        
        homeVC.analyticsScreen(nameVC: "wallet-VC")
        self.coinData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeCoinData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = walletView.dequeueReusableCell(withIdentifier: "walletCell") as! walletCell
        
        let index = followWalletName.index(of:homeCoinData[indexPath.row].short)!
        
        
        let tl = homeCoinData[indexPath.row].price*followWalletCoin[index]*(kurlar?.dolar)!
        
        
        let long = self.homeCoinData[indexPath.row].long
        let newLong = long.replacingOccurrences(of: " ", with: "-")
        let url = URL(string: "http://www.coincap.io/images/coins/\(newLong).png")
        
        cell.coinPrice.text = String(followWalletCoin[index]) + "\n " + homeCoinData[indexPath.row].short
        cell.coinName.text =  homeCoinData[indexPath.row].long
        cell.dollarPrice.text = "$" + String(homeCoinData[indexPath.row].price*followWalletCoin[index]).twoFractionDigits
        cell.tryPrice.text = "₺" + String(tl).twoFractionDigits
        cell.euroPrice.text = "€" + String(tl/(kurlar?.euro)!).twoFractionDigits
        cell.coinImage.kf.setImage(with: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: NSLocalizedString("del", comment: "")) { action, index in
            
            //self.followPageView.reloadData()
            tableView.beginUpdates()
            if  self.followWalletName.contains(self.homeCoinData[index.row].short){
                if let i = self.followWalletName.index(of: self.homeCoinData[index.row].short) {
                    
                    self.followWalletName.remove(at: i)
                    self.followWalletCoin.remove(at: i)
                }
            }
            self.homeCoinData.remove(at: index.row)
            self.walletView.reloadData()
            tableView.deleteRows(at:  [index], with: .fade)

            self.defaults.set(self.followWalletName, for: self.walletNamekey)
            self.defaults.set(self.followWalletCoin, for: self.walletCoinkey)
            coinSearchVC.showAlert(text:NSLocalizedString("errornotifi", comment: ""),theme: .error)
            
            tableView.endUpdates()
        }
        
        
        
        delete.backgroundColor = UIColor.red
        
        let edit = UITableViewRowAction(style: .normal, title: NSLocalizedString("edit", comment: "")) { action, index in
            
            //self.followPageView.reloadData()
            tableView.beginUpdates()
            self.editWallet(coin: self.homeCoinData[index.row].short)
            
            tableView.endUpdates()
        }
        
        edit.backgroundColor = UIColor.black
    
        
        return [delete,edit]
    }
    
    
    func editWallet(coin:String){
        //1. Create the alert controller.
        
        print(coin)
        
        let alert = UIAlertController(title: NSLocalizedString("awallet", comment: ""), message: NSLocalizedString("awalletdesc", comment: ""), preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            textField.placeholder =  NSLocalizedString("awalletplace", comment: "")
            if  self.followWalletName.contains(coin){
                if let i = self.followWalletName.index(of: coin) {
                    textField.text = String(self.followWalletCoin[i])
                }
            }
            //textField.textInputMode?.primaryLanguage
        }
        
        
        alert.addAction(UIAlertAction(title:"Cancel",style:.cancel,handler:{ [weak alert] (_) in
            
            
        }))
        
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let todouble =  Double((textField?.text as! String).replacingOccurrences(of: ",", with: "."))
            
            if  self.followWalletName.contains(coin){
                if let i = self.followWalletName.index(of: coin) {
                    self.followWalletCoin[i] = todouble!
                    self.defaults.set(self.followWalletCoin,for:self.walletCoinkey)
                    
                    self.walletView.reloadData()
                }
            }else{
                self.followWalletName.append(coin)
                self.followWalletCoin.append(todouble!)
                self.defaults.set(self.followWalletCoin,for:self.walletCoinkey)
                self.defaults.set(self.followWalletName,for:self.walletNamekey)
            }
            
            coinSearchVC.showAlert(text:NSLocalizedString("editnotifi", comment: ""),theme: .success)
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func coinData(){
        RouterUtility.shared.coin(callback: { response in
            
            if !response.hasError {
                self.homeCoinData = response.data
                self.homeCoinData = self.homeCoinData.filter{ self.followWalletName.contains($0.short) }
                
                Router.doviz = 1
                RouterUtility.shared.kurlar (callback: {response in
                    if !response.hasError {
                        self.kurlar = response.data
                        self.walletView.reloadData()
                    }
                })
            }
            
        })
    }
 
}
