//
//  coinSearchVC.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 10.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import UIKit
import Kingfisher
import DefaultsKit
import SwiftMessages
import LLSpinner

class coinSearchVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    var followShortName:[String] = []
    
    //For Shared Prefences
    let defaults = Defaults()
    let key = Key<[String]>("followList")
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UITableView!
    var homeCoinData:[Coin] = []
    var searchFiltered:[Coin] = []
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LLSpinner.spin()
        followShortName = defaults.get(for: key) ?? [""]
        
        searchBar.placeholder =  NSLocalizedString("searchPlace", comment: "")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(coinSearchVC.dismissKeyboard))
        
        navigationController?.navigationBar.addGestureRecognizer(tap)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Router.doviz = 0
        RouterUtility.shared.coin(callback: { response in
            
            if !response.hasError {
                self.homeCoinData = response.data
                self.searchFiltered = self.homeCoinData
                self.searchView.reloadData()

            }
        })
        
        
        homeVC.analyticsScreen(nameVC: "search-VC")
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
     
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.dismissKeyboard()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchFiltered = self.homeCoinData.filter{ $0.long.contains(searchText) || $0.short.contains(searchText) }
        print(searchText)
        print(self.searchFiltered)
        if(searchFiltered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
          self.searchView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive == true){
        return searchFiltered.count
        }
        return homeCoinData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchView.dequeueReusableCell(withIdentifier: "searchPageCell") as! searchPageCell
        if(searchFiltered.count > 0){
        let long = self.searchFiltered[indexPath.row].long
        let newLong = long.replacingOccurrences(of: " ", with: "-")
        let url = URL(string: "http://www.coincap.io/images/coins/\(newLong).png")
        
        cell.coinName.text = searchFiltered[indexPath.row].long
        cell.coinImage.kf.setImage(with: url)
        }else {
            let long = self.homeCoinData[indexPath.row].long
            let newLong = long.replacingOccurrences(of: " ", with: "-")
            let url = URL(string: "http://www.coincap.io/images/coins/\(newLong).png")
            
            cell.coinName.text = homeCoinData[indexPath.row].long
            cell.coinImage.kf.setImage(with: url)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "searchToCoinPage", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let insert = UITableViewRowAction(style: .normal, title: NSLocalizedString("follow", comment: "")) { action, index in
            //let coinShortName = CoinShort(short: self.homeCoinData[index.row].short)
            if self.followShortName.contains(self.searchFiltered[index.row].short) {
                print("bu zaten listede var")
                coinSearchVC.showAlert(text:NSLocalizedString("warningnotifi", comment: ""),theme: .warning)
                
            }else{
                self.followShortName.append(self.searchFiltered[index.row].short)
                self.defaults.set(self.followShortName,for:self.key)
                
                coinSearchVC.showAlert(text:NSLocalizedString("sucessnotifi", comment: ""),theme: .success)
            }
            print(self.followShortName)
        }
        insert.backgroundColor = UIColor.green
        
        return [insert]
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToCoinPage"{
            
            let index = searchView.indexPathForSelectedRow
            let coinProfilVC = segue.destination as! coinProfilVC
            coinProfilVC.coin = searchFiltered[(index?.row)!].short
            let aString = searchFiltered[(index?.row)!].long
            let newString = aString.replacingOccurrences(of: " ", with: "-")
            coinProfilVC.coinLong = newString
            
            
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    public class func showAlert(text:String,theme:Theme){
        let view = MessageView.viewFromNib(layout: .cardView)
        
        // Theme message elements with the warning style.
        view.configureTheme(theme)
        
        // Add a drop shadow.
        view.configureDropShadow()
        view.button?.isHidden = true
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        //let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
        view.configureContent(title: "Crypier", body: text)
        // Show the message.
        SwiftMessages.show(view: view)
    }
    
    
}
