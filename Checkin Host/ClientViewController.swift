//
//  ClientViewController.swift
//  Checkin
//
//  Created by Siyuan Gao on 5/25/15.
//  Copyright (c) 2015 Siyuan Gao. All rights reserved.
//

import UIKit
import Foundation

class ClientViewController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var freq: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = freq
    }
    override func didReceiveMemoryWarning() {
    }
}