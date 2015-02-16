//
//  Business.swift
//  Yelp
//
//  Created by Jianfeng Ye on 2/10/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import Foundation

let milesPerMeter: Float = 0.000621371

class Business {
    
    var name: String
    var thumbUrl: String
    var ratingImgUrl: String
    var distance: Float
    var address: String
    var category: String
    var ratingNum: Int
    var redirectUrl: String
    
    init(data: NSDictionary) {
        name = data["name"] as String
        
        thumbUrl = ""
        if let url: AnyObject = data["image_url"] {
            thumbUrl = url as String
        }
        let addressArray = (data.valueForKeyPath("location.address") as NSArray)
        let street =  addressArray.count > 0 ? addressArray[0] as String : ""
        var neighborhood = ""
        let neighborhoodArray = data.valueForKeyPath("location.neighborhoods") as? NSArray
        if let na = neighborhoodArray {
            neighborhood = na.count > 0 ? na[0] as String : ""
        }
        address = "\(street)"
        address += neighborhood == "" ? "" : ", \(neighborhood)"
        ratingImgUrl = data["rating_img_url"] as String
        
        distance = 0
        if let distanceData: AnyObject = data["distance"] {
            distance = (distanceData as Float) * milesPerMeter
        }
        ratingNum = data["review_count"] as Int
        var categoryNames = [String]()
        if let categoryData: AnyObject = data["categories"] {
            for c in categoryData as NSArray {
                categoryNames.append((c as NSArray)[0] as String)
            }
            category = ", ".join(categoryNames)
        } else {
            category = ""
        }
        
        redirectUrl = data["url"] as String
    }
    
}