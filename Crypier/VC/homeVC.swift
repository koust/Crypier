//
//  homeVC.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 9.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import UIKit
import FSLineChart
import Kingfisher
import DefaultsKit
import GoogleMobileAds
import LLSpinner
import SwiftyTimer

class homeVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var homeView: UITableView!
    @IBOutlet weak var homeChart: FSLineChart!
    @IBOutlet weak var bottomBanner: UIView!
    
    var bannerView:GADBannerView!
    var data: [Double] = []
    var timeChart: [String] = []
    var homeCoinData:[Coin] = []
    var historyPriceData:HistoryPrice?
    var followShortName:[String] = []
    var interstitial: GADInterstitial!

    //For Shared Prefences
    let defaults = Defaults()
    let key = Key<[String]>("followList")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        LLSpinner.spin()
    
        self.tabBarController?.tabBar.items?[0].title = NSLocalizedString("home", comment: "")
        self.tabBarController?.tabBar.items?[1].title = NSLocalizedString("search", comment: "")
        self.tabBarController?.tabBar.items?[2].title = NSLocalizedString("wallet", comment: "")
        self.tabBarController?.tabBar.items?[3].title = NSLocalizedString("settings", comment: "")
        
//         interstitial = GADInterstitial(adUnitID: "ca-app-pub-1076059588864028/3178117324")
//        let request = GADRequest()
//        interstitial.load(request)
     
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bottomBanner.addSubview(bannerView)
        
        
        bannerView.adUnitID = "ca-app-pub-1076059588864028/9436128248"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
//        bottomBanner.adUnitID = "ca-app-pub-1076059588864028/9436128248"
//        bottomBanner.rootViewController = self
//        bottomBanner.load(GADRequest())
//
        
        RouterUtility.shared.history(coin: "BTC", callback: {response in
            if !response.hasError {
             
                var timeZoneAbbreviations: String { return TimeZone.current.identifier}
             
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
        
          self.coinData()
 
        // Do any additional setup after loading the view.
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        followShortName = defaults.get(for: key) ?? [""]
        Router.doviz = 0
        
        Timer.every(60.seconds) { (timer: Timer) in
            self.coinData()
            
        }
        
        
        homeVC.analyticsScreen(nameVC: "Home-VC")
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeCoinData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeView.dequeueReusableCell(withIdentifier: "homeCoinCell") as! homeCoinCell
        cell.long.text = homeCoinData[indexPath.row].long
        cell.short.text = homeCoinData[indexPath.row].short
        cell.price.text =
            String(format: "$%.02f", homeCoinData[indexPath.row].price)
        cell.perc.text = String(homeCoinData[indexPath.row].perc) + "%"
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if interstitial.isReady {
//            interstitial.present(fromRootViewController: self)
//        }
        performSegue(withIdentifier: "coinPage", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let insert = UITableViewRowAction(style: .normal, title: NSLocalizedString("follow", comment: "")) { action, index in
            //let coinShortName = CoinShort(short: self.homeCoinData[index.row].short)
            if self.followShortName.contains(self.homeCoinData[index.row].short) {
                 coinSearchVC.showAlert(text:NSLocalizedString("warningnotifi", comment: ""),theme: .warning)
            }else{
            self.followShortName.append(self.homeCoinData[index.row].short)
            self.defaults.set(self.followShortName,for:self.key)
                coinSearchVC.showAlert(text:NSLocalizedString("sucessnotifi", comment: ""),theme: .success)
            }
            print(self.followShortName)
        }
        insert.backgroundColor = UIColor.green

        return [insert]
    }
    
    public func load() {
        // Generate some dummy data

        homeChart.backgroundColor = UIColor.clear
        homeChart.valueLabelTextColor = UIColor.white
        homeChart.valueLabelBackgroundColor = UIColor.clear
        homeChart.axisWidth = self.homeChart.frame.width-10
        
        //homeChart.margin = 25
        homeChart.indexLabelFont.withSize(13)
        homeChart.verticalGridStep = 5
        homeChart.horizontalGridStep = 6
        
        homeChart.labelForIndex = { index in
            return self.timeChart[Int(index)]
        }
        homeChart.labelForValue = { "$\($0)" }
        homeChart.setChartData(data)
    }

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "coinPage"{
            
            let index = homeView.indexPathForSelectedRow
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
                self.homeView.reloadData()
            }
        })
    }

    public class func analyticsScreen(nameVC:String){
    let name = nameVC
    
    guard let tracker = GAI.sharedInstance().defaultTracker else { return }
    tracker.set(kGAIScreenName, value: name)
    
    guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
    tracker.send(builder.build() as [NSObject : AnyObject])
    
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bottomBanner.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
 
}

