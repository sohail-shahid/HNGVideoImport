//
//  HNGHelperUtill.swift
//  Pods
//
//  Created by sohail khan on 20/01/2016.
//
//

import UIKit

class HNGHelperUtill: NSObject {
    
    
    // MARK:- Date Time Formatter

    class func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
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
