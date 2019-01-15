//
//  EventsTableViewCell.swift
//  SearchMyEvent
//

//

import UIKit

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImgView: UIImageView!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var favoriteView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.eventImgView.layer.cornerRadius = 5
        self.eventImgView.layer.masksToBounds = true
    }
    
    func configView(model:EventModel?){
        if let object = model{
            if let name = object.eventName{
                self.eventNameLbl.text = name
            }
            if let location = object.eventLocation{
                self.locationLbl.text = location
            }
            if let date = object.eventDate{
                self.dateTimeLbl.text = date
            }
            self.favoriteView.isHidden = !object.isFavorite
            weak var weakSelf = self
            if let imgUrl = object.eventImageUrl{
                NetworkManager.sharedInstance.downloadImage(fromURL: imgUrl, success: {image in
                    weakSelf?.eventImgView.image = image
                    object.eventImage = image
                    weakSelf?.reloadInputViews()
                })
            }
        }
    }
    
    override func prepareForReuse() {
        self.eventImgView.image = UIImage.init(named: "eventIcon")
        self.favoriteView.isHidden = true
    }
}
