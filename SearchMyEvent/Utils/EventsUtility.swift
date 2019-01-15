//
//  EventsUtility.swift
//  SearchMyEvent
//

//

import UIKit

class EventsUtility: NSObject {
    
    class func conventToDateString(utc:String) -> String{
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: utc)// create   date from string
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "EEE, dd MM yyyy , h:mm a"
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }
}
