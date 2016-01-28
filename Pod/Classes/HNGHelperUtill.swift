//
//  HNGHelperUtill.swift
//  Pods
//
//  Created by sohail khan on 20/01/2016.
//
//

import UIKit

extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in self.enumerate() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.removeAtIndex(index!)
        }
    }
}



class HNGHelperUtill: NSObject {
    
    
    // MARK:- Date Time Formatter

    class func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        //let hours = (interval / 3600)
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    
    class func getFormatededStringFromString(dateString: String)-> String{
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy - EEEE"

        let date = dateFormatter.dateFromString(dateString)
        dateFormatter.dateFormat = "MMM yyyy"
        let dateString = dateFormatter.stringFromDate(date!)
        return dateString
    }
    class func getFromatedStringFromDate(date:NSDate)-> String{
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy - EEEE"
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    // MARK:- Math Calculations
    class func scaledWidthWRTDesign(subviewWidth subviewWidth:CGFloat)-> CGFloat{ // with respect to six plus
        let referance = HNGConstants.referanceWidthForIPhones // widht of iPhone 6+ in landscape
        let currentScreen = screenWidth()
        let percentChange = (subviewWidth/referance) as CGFloat
        let newWidth : CGFloat = percentChange * currentScreen
        return newWidth
        
    }
    
    // MARK:-  View
    class func screenWidth()->CGFloat {
        return UIScreen.mainScreen().bounds.width // landscape
    }
}
