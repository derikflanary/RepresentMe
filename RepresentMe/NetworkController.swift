//
//  NetworkController.swift
//  RepresentMe
//
//  Created by Derik Flanary on 6/7/15.
//  Copyright (c) 2015 Derik Flanary. All rights reserved.
//

import UIKit
import Alamofire

class NetworkController: NSObject {
    
    
    func fetchData(urlString: String) {
        Alamofire.request(.GET, urlString).responseJSON { (_, _, JSON, ERROR) -> Void in
            
        }
        
    }
   
}
