//
//  DetailViewController.swift
//  RepresentMe
//
//  Created by Derik Flanary on 6/7/15.
//  Copyright (c) 2015 Derik Flanary. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum TableViewSection: Int{
        case Header, Name, Party, State, District, Phone, Address, Link
    }
    
    var responseDataArray = NSArray()
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        tableView = UITableView(frame: self.view.frame, style: .Grouped)
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView!)
        
        let congressController = CongressMemberController()
        congressController.fetchRepsByZip("84606", completion: { (dataArray) -> Void in
            println(dataArray)
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return 0
        }else{
            return 1
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 8
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch TableViewSection(rawValue: section)!{
        case .Header:
            return ""
        case .Name:
            return "Name"
        case .Party:
            return "Party"
        case .State:
            return "State"
        case .District:
            return "District"
        case .Phone:
            return "Phone"
        case .Address:
            return "Address"
        case .Link:
            return "Website"
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell :UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell()
        }
        cell?.selectionStyle = .None
        return cell!;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}


