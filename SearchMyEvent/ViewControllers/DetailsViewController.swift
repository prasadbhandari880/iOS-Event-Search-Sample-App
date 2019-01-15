//
//  DetailsViewController.swift
//  SearchMyEvent
//

//

import UIKit

class DetailsViewController: UIViewController {

    let emptyImg = UIImage.init(named: "emptyHeartIcon")
    let filledImg = UIImage.init(named: "heartIcon")
    var favFlag = false
    
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventImgView: UIImageView!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var eventLocationLbl: UILabel!
    
    var model: EventModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let object = model{
            favFlag = object.isFavorite
        }
        configFavBtn()
        configView()
        self.eventImgView.layer.cornerRadius = 5
        self.eventImgView.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configFavBtn(){
        if !favFlag{
            let favBtn = UIBarButtonItem(image: emptyImg, style: .plain, target: self, action: #selector(setFav(sender:)))
            favBtn.tintColor = UIColor.red
            self.navigationItem.rightBarButtonItem = favBtn
        }else{
            let favBtn = UIBarButtonItem(image: filledImg, style: .plain, target: self, action: #selector(setFav(sender:)))
            favBtn.tintColor = UIColor.red
            self.navigationItem.rightBarButtonItem = favBtn
        }
    }
    
    func configView(){
        if let object = model{
            if let name = object.eventName{
                self.eventNameLbl.text = name
            }
            if let location = object.eventLocation{
                self.eventLocationLbl.text = location
            }
            if let date = object.eventDate{
                self.dateTimeLbl.text = date
            }
            if let image = object.eventImage{
                self.eventImgView.image = image
            }else{
                if let imgUrl = object.eventImageUrl{
                    weak var weakSelf = self
                    NetworkManager.sharedInstance.downloadImage(fromURL: imgUrl, success: {image in
                        weakSelf?.eventImgView.image = image
                        object.eventImage = image
                    })
                }
            }
        }
    }
    
    @objc func setFav(sender: UIBarButtonItem) {
        if favFlag{
            sender.image = emptyImg
        }else{
            sender.image = filledImg
        }
        
        if let object = model{
            if let id = object.eventId{
                if favFlag{
                    CoreDataHelper.sharedInstance.removeEventFromFavorites(eventId: id)
                    object.isFavorite = false
                }else{
                    CoreDataHelper.sharedInstance.addEventToFavorites(eventId: id)
                    object.isFavorite = true
                }
            }
        }
        favFlag = !favFlag
    }
}
