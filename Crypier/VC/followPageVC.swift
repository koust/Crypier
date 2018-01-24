//
//  followPageVC.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 15.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import UIKit
import DefaultsKit
import LLSpinner
import SwiftyTimer

class followPageVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var followPageView: UITableView!
    var homeCoinData:[Coin] = []
    var followShortName:[String] = []
    
    //For Shared Prefences
    let defaults = Defaults()
    let key = Key<[String]>("followList")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LLSpinner.spin()
        followShortName = defaults.get(for: key) ?? [""]
        self.coinData()
        self.navigationItem.title = NSLocalizedString("followlist", comment: "")
        // Do any additional setup after loading the view.

        
    
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Router.doviz = 0
        Timer.every(60.seconds) { (timer: Timer) in
            self.coinData()
        }
        
        
        homeVC.analyticsScreen(nameVC: "follow-VC")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeCoinData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = followPageView.dequeueReusableCell(withIdentifier: "homeCoinCell") as! homeCoinCell
        
        
        cell.long.text = homeCoinData[indexPath.row].long
        cell.short.text = homeCoinData[indexPath.row].short
        cell.price.text =
            String(format: "$%.02f", homeCoinData[indexPath.row].price)
        cell.perc.text = String(homeCoinData[indexPath.row].perc) + "%"
        
        // for Image
        let long = self.homeCoinData[indexPath.row].long
        let newLong = long.replacingOccurrences(of: " ", with: "-")
        let url = URL(string: "http://www.coincap.io/images/coins/\(newLong).png")
        cell.coinImage.kf.setImage(with: url)
        
        
        
        let string = String(homeCoinData[indexPath.row].perc)
        let needle: Character = "-"
        if let idx = string.characters.index(of: needle) {
            
            cell.perc.textColor = UIColor.red
        }else if string == "0" {
            cell.perc.textColor = UIColor.orange
        }else {
            cell.perc.textColor = UIColor.green
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: NSLocalizedString("del", comment: "")) { action, index in
            
            //self.followPageView.reloadData()
            tableView.beginUpdates()
            
            self.homeCoinData.remove(at: index.row)
            self.followPageView.reloadData()
            tableView.deleteRows(at:  [index], with: .fade)
            self.followShortName.remove(at: index.row)
            self.defaults.set(self.followShortName, for: self.key)
            
            coinSearchVC.showAlert(text:NSLocalizedString("errornotifi", comment: ""),theme: .error)
            tableView.endUpdates()
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "followToCoinPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "followToCoinPage"{
            
            let index = followPageView.indexPathForSelectedRow
            let coinProfilVC = segue.destination as! coinProfilVC
            coinProfilVC.coin = homeCoinData[(index?.row)!].short
            let aString = homeCoinData[(index?.row)!].long
            let newString = aString.replacingOccurrences(of: " ", with: "-")
            coinProfilVC.coinLong = newString
            
            
        }
    }
    
    
    func coinData(){
        RouterUtility.shared.coin(callback: { response in
            
            if !response.hasError {
                self.homeCoinData = response.data
                self.homeCoinData = self.homeCoinData.filter{ self.followShortName.contains($0.short) }
                self.followPageView.reloadData()
            }
        })
    }

}
