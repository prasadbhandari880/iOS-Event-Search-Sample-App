//
//  EventModel.swift
//  SearchMyEvent
//

//

import UIKit

class EventModel: NSObject {
    var eventId: Double?
    var eventName: String?
    var eventDate: String?
    var eventLocation: String?
    var eventImageUrl: String?
    var eventImage: UIImage?
    var isFavorite: Bool = false
    
    init(With dictionary:[String:Any]?) {
        super.init()
        if let dict = dictionary{
            if let nodeValue = dict["datetime_utc"] as? String{
                self.eventDate = EventsUtility.conventToDateString(utc: nodeValue)
            }
            if let nodeValue = dict["title"]{
                self.eventName = nodeValue as? String
            }
            if let nodeValue = dict["performers"] as? [Any]{
                if let node = nodeValue.first as? [String:Any]{
                    if let imgUrl = node["image"] as? String{
                        self.eventImageUrl = imgUrl
                    }
                }
            }
            if let nodeValue = dict["id"]{
                self.eventId = (nodeValue as? NSNumber)?.doubleValue
            }
            if let id = eventId{
                let events = CoreDataHelper.sharedInstance.getEventByEventId(eventId: id)
                if let event = events.first{
                    if id == event.eventId{
                        self.isFavorite = true
                    }
                }
            }
            
            if let nodeValue = dict["venue"] as? [String:Any]{
                var location = ""
                if let city = nodeValue["city"] as? String{
                    location += city
                }
                if let state = nodeValue["state"] as? String{
                    location += ", " + state
                }
                self.eventLocation = location
            }
        }
    }
}
