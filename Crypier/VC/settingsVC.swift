//
//  SettingsVC.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 15.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import UIKit
import CDAlertView


class settingsVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var settingsView: UITableView!
    
    let menuItems:[String] = [NSLocalizedString("about", comment: ""),NSLocalizedString("notifi", comment: ""),NSLocalizedString("wallet", comment: "")]
    let menuContents:[String] = [NSLocalizedString("aboutContent", comment: ""),
                                 NSLocalizedString("notifiContent", comment: ""),
                                 NSLocalizedString("walletcontent", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsView.reloadData()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsView.dequeueReusableCell(withIdentifier: "settingsCell") as! settingsCell
        cell.settingName.text = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      let alert =  CDAlertView(title: menuItems[indexPath.row], message: menuContents[indexPath.row], type: .notification )
        
        if(indexPath.row == 1){
            let notifi = CDAlertViewAction(title: NSLocalizedString("enable", comment: ""),handler: { action in
                
   
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        // Checking for setting is opened or not
                        print("Setting is opened: \(success)")
                    })
                }
      
            
            })
            
            let doneAction = CDAlertViewAction(title: NSLocalizedString("done", comment: ""),handler: { action in
                
                print("tıklandı")
            })
            alert.add(action: notifi)
            alert.add(action: doneAction)
        }
        
        alert.show();
    }

}
