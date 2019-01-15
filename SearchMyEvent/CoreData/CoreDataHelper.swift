//
//  CoreDataHelper.swift
//  SearchMyEvent
//

//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    static let sharedInstance = CoreDataHelper()
    let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private override init() {
        super.init()
    }
    
    
    //Get All Favorite Events
    func getAllFavoriteEvents() -> [FavoriteEvent]{
        var events = [FavoriteEvent]()
        let request : NSFetchRequest = FavoriteEvent.fetchRequest()
        do{
            events = try context.fetch(request)
        }catch{
            print("Unable to fetch data")
        }
        return events
    }
    
    //Add Events to Favorites
    func addEventToFavorites(eventId:Double){
        let event = FavoriteEvent(context: context)
        event.eventId = eventId
        APP_DELEGATE.saveContext()
    }
    
    // Remove Event from Favorites
    func removeEventFromFavorites(eventId:Double){
        let eventArray = getEventByEventId(eventId: eventId)
        if let event = eventArray.first{
            context.delete(event)
        }
        APP_DELEGATE.saveContext()
    }
    
    //GET Event By Event Id
    func getEventByEventId(eventId:Double) -> [FavoriteEvent]{
        var events = [FavoriteEvent]()
        let request : NSFetchRequest = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "eventId == %f", eventId)
        do{
            events = try context.fetch(request)
        }catch{
            print("Unable to fetch data")
        }
        return events
    }
}
