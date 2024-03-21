//
//  UniPortalAdminCell.swift
//  USW Connect
//
//  Created by ekincare on 16/03/24.
//

import UIKit

class UniPortalAdminCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var marketingLbael: UILabel!
    @IBOutlet weak var correspondingLabel: UILabel!
    @IBOutlet weak var nameDataLabel: UILabel!
    @IBOutlet weak var emailDataLabel: UILabel!
    @IBOutlet weak var dobDataLabel: UILabel!
    @IBOutlet weak var locationDataLabel: UILabel!
    
    @IBOutlet weak var marketingDataLabel: UILabel!
    @IBOutlet weak var corresDataLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.roundCorners([.allCorners], radius: 8.0)
        mainView.layer.borderWidth = 1.0
        mainView.layer.borderColor = colore5e8f0.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func setData(data:[String:Any]) {
        fullNameLabel.setText(text: "FULL NAME", withKerning: 1.0)
        dobLabel.setText(text: "DATE OF BIRTH", withKerning: 1.0)
        emailLabel.setText(text: "EMAIL", withKerning: 1.0)
        locationLabel.setText(text: "POSTCODE", withKerning: 1.0)
        marketingLbael.setText(text: "MARKETING UPDATES", withKerning: 1.0)
        correspondingLabel.setText(text: "CORRESPONDING UPDATES", withKerning: 1.0)

        nameDataLabel.text = data.getStringValue(key: "full_name")
        dobDataLabel.text = data.getStringValue(key: "date_of_birth")
        emailDataLabel.text = data.getStringValue(key: "email")
        locationDataLabel.text = data.getStringValue(key: "gps_location")
        marketingDataLabel.textColor = (data.getBoolValue(key: "marketing_updates")) ? color0E9347 : colorCD173C
        marketingDataLabel.text = (data.getBoolValue(key: "marketing_updates") ? "Yes" : "No")
        corresDataLabel.text = (data.getBoolValue(key: "correspondence_in_welsh") ? "Yes" : "No")
        corresDataLabel.textColor = (data.getBoolValue(key: "correspondence_in_welsh")) ? color0E9347 : colorCD173C
    }
    
}
