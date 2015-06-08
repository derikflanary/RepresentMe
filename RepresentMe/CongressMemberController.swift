//
//  CongressMemberController.swift
//  RepresentMe
//
//  Created by Derik Flanary on 6/7/15.
//  Copyright (c) 2015 Derik Flanary. All rights reserved.
//

import UIKit
import Alamofire

class CongressMemberController: NSObject {
    
    var data: NSMutableData = NSMutableData()
    
    class Singleton  {
        static let sharedInstance = Singleton()
        func pathForRepByZip(zip: String) -> String{
            return NSString(format:"http://whoismyrepresentative.com/getall_mems.php?zip=%@&output=json", zip) as String
        }
        
        func fetchRepsByZip(zip: String, completion: (NSMutableArray) -> Void) {
            //Get api url
            let urlString: String = pathForRepByZip(zip)
            
            Alamofire.request(.GET, urlString).responseJSON { (_, _, JSON, ERROR) -> Void in
                //Check if json returned
                if JSON != nil{
                    //Convert Json to Array
                    let responseDictionary = JSON as! NSDictionary
                    var responseArray = NSArray()
                    var congressmen = NSMutableArray()
                    responseArray = responseDictionary["results"] as! NSArray
                    for dict in responseArray{
                        //Convert json array to congress member objects in an array
                        var congressMember = CongressMember(dictionary: dict as! NSDictionary)
                        println(congressMember.name)
                        congressmen.addObject(congressMember)
                    }
                    completion(congressmen)
                }else{
                    //Return an empty array
                    var congressmen = NSMutableArray()
                    completion(congressmen)
                }
            }
        }
    }
}
