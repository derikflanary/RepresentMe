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
    
//    class SharedInstance {
//        class var sharedInstance :SharedInstance {
//            struct Singleton {
//                static let instance = SharedInstance()
//            }
//            return Singleton.instance
//        }
//    }

    func pathForRepByZip(zip: String) -> String{
    return NSString(format:"http://whoismyrepresentative.com/getall_mems.php?zip=%@&output=json", zip) as String
    
    }
    
    func fetchRepsByZip(zip: String, completion: (NSMutableArray) -> Void) {
        let urlString: String = pathForRepByZip(zip)
        Alamofire.request(.GET, urlString).responseJSON { (_, _, JSON, ERROR) -> Void in
//            println(JSON)
            
            let responseDictionary = JSON as! NSDictionary
            var responseArray = NSArray()
            var congressmen = NSMutableArray()
            responseArray = responseDictionary["results"] as! NSArray
            for dict in responseArray{
                var congressMember = CongressMember(dictionary: dict as! NSDictionary)
                println(congressMember.name)
                congressmen.addObject(congressMember)
            }
            
            completion(congressmen)
            
        }
        
    }

}
