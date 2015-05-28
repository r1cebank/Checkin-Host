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

class HostViewController: UIViewController, MPCManagerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var freq: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var connectCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = freq
    }
    
    override func viewWillAppear(animated: Bool) {
        appDelegate.mpcManager.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleMPCReceivedDataWithNotification:", name: "receivedMPCDataNotification", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleMPCReceivedDataWithNotification(notification: NSNotification) {
        log.verbose("Received data from client")
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        let data = receivedDataDictionary["data"] as? NSData
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! Dictionary<String, AnyObject>
        if let message = dataDictionary["message"] as? Dictionary<String, String> {
            if let checkInID = message["checkin"] {
                log.verbose("Got id: \(checkInID)")
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
    }
    
    func foundPeer() {
        
    }
    func lostPeer() {
        
    }
    func invitationWasReceived(fromPeer: String) {
    }
    
    @IBAction func checkinClicked(sender: UIButton) {
        performSegueWithIdentifier("showCheckinViewSegue", sender: nil)
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