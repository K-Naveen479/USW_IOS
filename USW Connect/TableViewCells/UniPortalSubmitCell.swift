//
//  UniPortalSubmitCell.swift
//  USW Connect
//
//  Created by ekincare on 11/03/24.
//

import UIKit

protocol UniPortalSubmitCellProtocol : AnyObject {
    func submitButtonClicked()
}

class UniPortalSubmitCell: UITableViewCell {

    @IBOutlet weak var submitButton: UIButton!
    
    weak var delegate : UniPortalSubmitCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func submitClicked(_ sender: UIButton) {
        delegate?.submitButtonClicked()
    }
}
