//
//  ViewController.swift
//  Crypier
//
//  Created by Batuhan Saygılı on 9.01.2018.
//  Copyright © 2018 batuhansaygili. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Connectivity.isConnectedToInternet() {
            DispatchQueue.main.async(execute: {
                
                self.performSegue(withIdentifier: "start", sender: self)
                })
        }else {
            coinSearchVC.showAlert(text:  NSLocalizedString("connectionoff", comment: ""), theme: .error)
        }
    }



}

