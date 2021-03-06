//
//  ViewController.swift
//  RepresentMe
//
//  Created by Derik Flanary on 6/7/15.
//  Copyright (c) 2015 Derik Flanary. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftSpinner

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    
    var tableView: UITableView?
    let tapGesture = UITapGestureRecognizer()
    var zipFromTextField: String = ""
    var zipFromLocation: String = ""
    var canSearchByZip: Bool = false
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor();
        self.title = "RepresentMe"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "lauchImage.png")
        imageView.frame = self.view.bounds
        self.view.addSubview(imageView)
        
        tableView = UITableView(frame: CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height), style: .Grouped)
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.registerClass(TextFieldTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.backgroundColor = UIColor(white: 1, alpha: 0.7)
        self.view.addSubview(tableView!)
        
        //tap gesture to close keyboard
        tapGesture.addTarget(self, action: "viewTapped")
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func viewTapped(){
        //resign keyboard
        self.view.endEditing(true)
    }
    
//TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Find Your Representatives"
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell :TextFieldTableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? TextFieldTableViewCell
        if cell == nil {
            cell = TextFieldTableViewCell()
        }
        if indexPath.row == 0{
            cell?.textField.placeholder = "Search by ZIP code"
            cell?.textField.text = zipFromTextField
            cell?.textField.delegate = self
            cell?.userInteractionEnabled = true
            var length = count(zipFromTextField)
            if length == 5{
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }else{
                cell?.accessoryType = UITableViewCellAccessoryType.None
            }
        }else{
            cell?.textLabel?.text = "Search by your current location";
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.textField.removeFromSuperview()
            cell?.userInteractionEnabled = true
        }
        
        return cell!;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        if indexPath.row == 0{
            let congressController = CongressMemberController()
            CongressMemberController.Singleton.sharedInstance.fetchRepsByZip(zipFromTextField, completion: { (dataArray) -> Void in
                if dataArray.count == 0{
                    
                    let alertController: UIAlertController = UIAlertController(title: "Invalid ZIP Code", message: "Please enter a valid U.S. ZIP code", preferredStyle: .Alert)
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Cancel) { action -> Void in
                        tableView.deselectRowAtIndexPath(indexPath, animated: true)
                        var indexPath = NSIndexPath(forRow: 0, inSection: 0)
                        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)

                }else{
                    var detailViewController = DetailViewController()
                    detailViewController.responseDataArray = dataArray
                    detailViewController.title = self.zipFromTextField
                    self.navigationController?.pushViewController(detailViewController, animated: true)
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                }
            })
        }else if indexPath.row == 1{
            currentLocationIdentifier()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
//Location Methods
    func currentLocationIdentifier(){
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        //Check if Device has ios8
        switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
        case .OrderedSame, .OrderedDescending:
            locationManager.requestWhenInUseAuthorization()
        case .OrderedAscending:
            println("iOS < 8.0")
        }
        
        locationManager.startUpdatingLocation()
        SwiftSpinner.show("Getting Your Current Location", animated: true)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        var currentLocation = CLLocation();
        locationManager.stopUpdatingLocation()
        
        //Reverse Geocode to find zipcode of current location
        var geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            if (error != nil){
                println("Reverse geocoder failed with error", error.localizedDescription)
            }else{
                let pm = placemarks[0] as! CLPlacemark
                self.zipFromLocation = pm.postalCode
                let congressController = CongressMemberController()
                CongressMemberController.Singleton.sharedInstance.fetchRepsByZip(self.zipFromLocation, completion: { (dataArray) -> Void in
                    //Check if Invalid Zip
                    SwiftSpinner.hide()
                    if dataArray.count == 0{
                        let alertController: UIAlertController = UIAlertController(title: "Invalid ZIP Code", message: "Could not find a valid zip code at your current location", preferredStyle: .Alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Cancel) { action -> Void in
                            return
                        }
                        alertController.addAction(cancelAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    //If valid zip
                    }else{
                        var detailViewController = DetailViewController()
                        detailViewController.responseDataArray = dataArray
                        detailViewController.title = self.zipFromLocation
                        self.navigationController?.pushViewController(detailViewController, animated: true)
                    }
                })
            }
        })
    }
    
//TextField Delegate
    func textFieldDidEndEditing(textField: UITextField){
        zipFromTextField = textField.text
        var indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = count(textField.text.utf16) + count(string.utf16) - range.length
        return newLength <= 5
    }
    
//other Functions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

