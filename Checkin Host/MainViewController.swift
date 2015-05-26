//
//  ViewController.swift
//  Checkin
//
//  Created by Siyuan Gao on 5/24/15.
//  Copyright (c) 2015 Siyuan Gao. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import XCGLogger
import SwiftSpinner

class MainViewController: UIViewController, MPCManagerDelegate{
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var freq1: UIButton!
    @IBOutlet weak var freq2: UIButton!
    @IBOutlet weak var freq3: UIButton!
    @IBOutlet weak var freq4: UIButton!
    @IBOutlet weak var freq5: UIButton!
    @IBOutlet weak var freq6: UIButton!
    @IBOutlet weak var codeLabel: UILabel!
    
    var code: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        freq1.setTitle(freq[0], forState: UIControlState.Normal)
        freq2.setTitle(freq[1], forState: UIControlState.Normal)
        freq3.setTitle(freq[2], forState: UIControlState.Normal)
        freq4.setTitle(freq[3], forState: UIControlState.Normal)
        freq5.setTitle(freq[4], forState: UIControlState.Normal)
        freq6.setTitle(freq[5], forState: UIControlState.Normal)
        code = [String]()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func viewWillAppear(animated: Bool) {
        code.removeAll(keepCapacity: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func foundPeer() {
        log.verbose("Peer Found")
    }
    
    func lostPeer() {
        log.verbose("Peer Lost")
    }
    
    func invitationWasReceived(fromPeer: String) {
        
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        let ids = peerID.displayName.componentsSeparatedByString("-")
        if(ids[ids.count - 1] == "host") {
            log.verbose("found the host")
            SwiftSpinner.show("Host connected!", animated: true)
            self.performSegueWithIdentifier("showClientViewSegue", sender: nil)
        }
        
    }

    @IBAction func buttonToggle(sender: UIButton!) {
        sender.toggleButton()
        if sender.selected {
            code.append(sender.titleLabel!.text!)
        } else {
            code.removeObject(sender.titleLabel!.text!)
        }
        codeLabel.text = "-".join(code)
    }

    @IBAction func connectClicked(sender: UIButton) {
        if(sender.selected) {
            log.verbose("Stopping...")
            if(appDelegate.mpcManager != nil) {
                appDelegate.mpcManager.browser.stopBrowsingForPeers()
                appDelegate.mpcManager.advertiser.stopAdvertisingPeer()
                appDelegate.mpcManager = nil
                log.verbose("Stopped")
            }
        } else {
            log.verbose("Frequency: \(self.codeLabel.text!)")
            appDelegate.mpcManager = MPCManager(freq: codeLabel.text!)
            appDelegate.mpcManager.delegate = self
            appDelegate.mpcManager.browser.startBrowsingForPeers()
            appDelegate.mpcManager.advertiser.startAdvertisingPeer()
            SwiftSpinner.show("waiting for host", animated: true)
        }
        sender.toggleButton()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! == "showClientViewSegue") {
            log.verbose("Preparing to show clientView")
            let targetVC = segue.destinationViewController as! ClientViewController
            targetVC.freq = codeLabel.text!
        }
    }
}

extension UIButton {
    func toggleButton() {
        selected = !selected
    }
}

extension Array {
    func indexOfObject(object : AnyObject) -> NSInteger {
        return (self as! NSArray).indexOfObject(object)
    }
    
    mutating func removeObject(object : AnyObject) {
        for var index = self.indexOfObject(object); index != NSNotFound; index = self.indexOfObject(object) {
            self.removeAtIndex(index)
        }
    }
}

