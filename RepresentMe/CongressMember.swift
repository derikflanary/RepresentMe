//
//  CongressMember.swift
//  RepresentMe
//
//  Created by Derik Flanary on 6/7/15.
//  Copyright (c) 2015 Derik Flanary. All rights reserved.
//

import UIKit

class CongressMember: NSObject {
    
    var name : String
    var party : String
    var state : String
    var district : String
    var phone : String
    var address : String
    var link : String
    
    init(dictionary: NSDictionary) {
        name = (dictionary["name"] as? String)!
        party = (dictionary["party"] as? String)!
        state = (dictionary["state"] as? String)!
        district = (dictionary["district"] as? String)!
        phone = (dictionary["phone"] as? String)!
        address = (dictionary["office"] as? String)!
        link = (dictionary["link"] as? String)!

    }
    
}
