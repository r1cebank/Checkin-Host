//
//  QuizViewController.swift
//  Checkin Host
//
//  Created by Siyuan Gao on 5/28/15.
//  Copyright (c) 2015 Siyuan Gao. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class QuizViewController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var checkedUser: [String: String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleMPCReceivedDataWithNotification:", name: "receivedMPCDataNotification", object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
    }
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func actionClicked(sender: UIButton) {
        let message: [String: String] = ["message" : "quiz"]
        appDelegate.mpcManager.sendData(dictionaryWithData: message)
    }
    
    func handleMPCReceivedDataWithNotification(notification: NSNotification) {
        log.verbose("Received data from client")
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        let data = receivedDataDictionary["data"] as? NSData
        let peer = receivedDataDictionary["fromPeer"] as! MCPeerID
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! Dictionary<String, AnyObject>
        if let message = dataDictionary["message"] as? Dictionary<String, String> {
            if let checkInID = message["checkin"] {
                log.verbose("Got id: \(checkInID)")
                if(checkedUser[peer.displayName!] == nil) {
                    checkedUser[peer.displayName!] = checkInID
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            //
        })
    }
}