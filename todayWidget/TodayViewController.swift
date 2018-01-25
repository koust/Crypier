//
//  TodayViewController.swift
//  todayWidget
//
//  Created by Batuhan Saygılı on 23.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import UIKit
import Kingfisher
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var wTitle: UILabel!
    @IBOutlet weak var wPrice: UILabel!
    @IBOutlet weak var wPerc: UILabel!
    @IBOutlet weak var wImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !Connectivity.isConnectedToInternet() {
            
            self.wTitle.text = NSLocalizedString("connectionoff", comment: "")
            self.wPrice.text = ""
            self.wPerc.text = ""
            
            return
        }
        RouterUtility.shared.coinPage(coin: "BTC", callback: {response in
            
            if !response.hasError {
                
                let long = response.data.display_name
                let newLong = long.replacingOccurrences(of: " ", with: "-")
                let url = URL(string: "http://www.coincap.io/images/coins/\(newLong).png")
                self.wImage.kf.setImage(with: url)
                
                self.wTitle.text = NSLocalizedString("today", comment: "") + " " + response.data.display_name
                self.wPrice.text = "$" + String(response.data.price)
                self.wPerc.text =  String(response.data.cap24hrChange) + "%"
                let string = String(response.data.cap24hrChange)
                let needle: Character = "-"
                if let idx = string.characters.index(of: needle) {
                    
                    self.wPerc.textColor = UIColor.red
                }else if string == "0" {
                    self.wPerc.textColor = UIColor.orange
                }else {
                    self.wPerc.textColor = UIColor.green
                }
            }
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
