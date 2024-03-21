//
//  UniPortalChecksCell.swift
//  USW Connect
//
//  Created by ekincare on 11/03/24.
//

import UIKit

protocol UniPortalChecksCellProtocol : AnyObject {
    func storeSwitchCondition(check:String,indexpath:Int)
}

class UniPortalChecksCell: UITableViewCell {

    @IBOutlet weak var checksLabel: UILabel!
    @IBOutlet weak var switchCheck: UISwitch!
    
    weak var delegate : UniPortalChecksCellProtocol?
    
    var indexpath = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchClicked(_ sender: UISwitch) {
        delegate?.storeSwitchCondition(check: sender.isOn ? "Yes" : "No",indexpath:indexpath)
    }
}
