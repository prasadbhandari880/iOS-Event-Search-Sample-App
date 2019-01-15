//
//  NetworkManager.swift
//  SearchMyEvent
//

//

import UIKit
import Alamofire

class NetworkManager: NSObject {
    static let sharedInstance = NetworkManager()
    static let coreUrl = "https://api.seatgeek.com/2/events"
    static let client_id = "MTA5NTgwMTd8MTUyMTc0MTQ0NC4wOQ"
    
    private override init() {
        super.init()
    }
    

    func getEventsBy(Name name:String, success:@escaping ([EventModel])->Void, error:@escaping (Error)->Void){
        
        var queryStr = ""
        let parts = name.split(separator: " ")
        for part in parts{
            if queryStr == ""{
                queryStr = String(part)
            }else{
                queryStr += "+" + String(part)
            }
        }
        
        var params : [String:String] = ["q": queryStr]
        params["client_id"] = NetworkManager.client_id
        
        request(NetworkManager.coreUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {response in
            if response.result.isSuccess{
                let object = response.result.value
                if let obj = object as? [String:Any]{
                    if let events = obj["events"] as? [Any]{
                        var eventList = [EventModel]()
                        for event in events{
                            let model = EventModel.init(With: event as? [String:Any])
                            eventList.append(model)
                        }
                        success(eventList)
                    }
                }
            }else{
                error(response.error!)
            }
        })
    }
    
    
    /** Download and Cache Image in File Directory */
    func downloadImage(fromURL url:String,success:@escaping (UIImage) -> Void) {
        let urlParts = url.components(separatedBy: "/")
        var fileName = ""
        if urlParts.count > 2{
            fileName += urlParts[urlParts.count - 2] + urlParts[urlParts.count - 1]
        }
        
        let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = directoryURLs.appendingPathComponent(fileName)
        let fileUrl = filePath.path
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: fileUrl){
            let image = UIImage.init(contentsOfFile: fileUrl)
            if let img = image{
                success(img)
            }
        }else{
            request(url).responseData(completionHandler: {response in
                if let data = response.data{
                    let image = UIImage.init(data: data)
                    if let img = image{
                        do{
                            try data.write(to: filePath)
                        }catch{
                            print("Unable to write")
                        }
                        success(img)
                    }
                }
            })
        }
    }
    
}
