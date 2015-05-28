//
//  CheckinViewController.swift
//  Checkin Host
//
//  Created by Siyuan Gao on 5/27/15.
//  Copyright (c) 2015 Siyuan Gao. All rights reserved.
//

import Foundation
import UIKit

class CheckinViewController: UIViewController, UITableViewDataSource {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var checkedUser: [String]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleMPCReceivedDataWithNotification:", name: "receivedMPCDataNotification", object: nil)
        checkedUser = [String]()
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
    }
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func checkinClicked(sender: UIButton) {
        let message: [String: String] = ["message" : "checkin"]
        appDelegate.mpcManager.sendData(dictionaryWithData: message)
    }
    
    func handleMPCReceivedDataWithNotification(notification: NSNotification) {
        log.verbose("Received data from client")
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        let data = receivedDataDictionary["data"] as? NSData
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! Dictionary<String, AnyObject>
        if let message = dataDictionary["message"] as? Dictionary<String, String> {
            if let checkInID = message["checkin"] {
                log.verbose("Got id: \(checkInID)")
                if(checkedUser.indexOfObject(checkInID) == NSNotFound) {
                    checkedUser.append(checkInID)
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkedUser.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell") as! UITableViewCell
        cell.textLabel?.text = checkedUser[indexPath.row]
        cell.detailTextLabel?.text = "checked"
        return cell
    }
    
}