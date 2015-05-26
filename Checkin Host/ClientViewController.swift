//
//  ClientViewController.swift
//  Checkin
//
//  Created by Siyuan Gao on 5/25/15.
//  Copyright (c) 2015 Siyuan Gao. All rights reserved.
//

import UIKit
import Foundation
import MultipeerConnectivity

class ClientViewController: UIViewController, MPCManagerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var freq: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var connectCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        titleLabel.text = freq
    }
    
    override func viewWillAppear(animated: Bool) {
        appDelegate.mpcManager.delegate = self
    }
    
    
    override func didReceiveMemoryWarning() {
    }
    
    func foundPeer() {
        
    }
    func lostPeer() {
        
    }
    func invitationWasReceived(fromPeer: String) {
    }
    func connectedWithPeer(peerID: MCPeerID) {
        log.verbose("Connected with a client")
        dispatch_async(dispatch_get_main_queue(), {
            self.connectCountLabel.text = String(self.appDelegate.mpcManager.sessions.count)
        })
        log.verbose(String(self.appDelegate.mpcManager.sessions.count))
    }
    
    func disconnectedWithPeer(peerID: MCPeerID) {
        dispatch_async(dispatch_get_main_queue(), {
            self.connectCountLabel.text = String(self.appDelegate.mpcManager.sessions.count)
        })
    }
}