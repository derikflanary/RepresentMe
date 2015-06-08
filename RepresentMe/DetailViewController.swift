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
    var segmentedControl : UISegmentedControl?
    var link = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.tableView = UITableView(frame: self.view.frame, style: .Grouped)
        self.tableView!.dataSource = self
        self.tableView!.delegate = self
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView!)
        
        let titleArray = ["Representative", "Sr. Senator", "Jr. Senator"]
        segmentedControl = UISegmentedControl(items: titleArray)
        segmentedControl?.frame = CGRectMake(0, 0, self.view.frame.size.width, 44)
        segmentedControl?.tintColor = UIColor.lightGrayColor()
        segmentedControl?.selectedSegmentIndex = 0
        segmentedControl?.addTarget(self, action: "segmentedControlChangedValue", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func segmentedControlChangedValue(){
        self.tableView!.reloadData()
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        if section == 0{
            headerView.addSubview(segmentedControl!)
            return headerView
        }
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell :UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell()
        }
        cell?.selectionStyle = .None
        var congressMember = CongressMember()
        if responseDataArray.count == 0{
            
        }else{
            if segmentedControl?.selectedSegmentIndex == 0{
                congressMember = responseDataArray.objectAtIndex(0) as! CongressMember
            }else if segmentedControl?.selectedSegmentIndex == 1{
                if responseDataArray.count > 3 {
                    congressMember = responseDataArray.objectAtIndex(2) as! CongressMember
                }else{
                    congressMember = responseDataArray.objectAtIndex(1) as! CongressMember
                }
            }else{
                if responseDataArray.count > 3 {
                    congressMember = responseDataArray.objectAtIndex(3) as! CongressMember
                }else{
                    congressMember = responseDataArray.objectAtIndex(2) as! CongressMember
                }

            }
            
            switch TableViewSection(rawValue: indexPath.section)!{
            case .Header:
                cell?.textLabel?.text = ""
            case .Name:
                cell?.textLabel?.text = congressMember.name
            case .Party:
                cell?.textLabel?.text = congressMember.party
            case .State:
                cell?.textLabel?.text = congressMember.state
            case .District:
                cell?.textLabel?.text = congressMember.district
            case .Phone:
                cell?.textLabel?.text = congressMember.phone
            case .Address:
                cell?.textLabel?.text = congressMember.address
            case .Link:
                cell?.textLabel?.text = congressMember.link
                cell?.selectionStyle = UITableViewCellSelectionStyle.Default
                link = congressMember.link
            }
        }
        return cell!;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 7{
            UIApplication.sharedApplication().openURL(NSURL(string: link)!)
        }
    }
}


