//
//  UniPortalLandingPage.swift
//  USW Connect
//
//  Created by ekincare on 13/03/24.
//

import UIKit

class UniPortalLandingPage: UIViewController {

    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var studentButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var welcomeLabelTop: NSLayoutConstraint!
    @IBOutlet weak var logoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageWidth: NSLayoutConstraint!
    @IBOutlet weak var logoImageHeight: NSLayoutConstraint!
    @IBOutlet weak var borderLabelTop: NSLayoutConstraint!
    @IBOutlet weak var borderLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var bgViewBottom: NSLayoutConstraint!
    
    let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        bgView.bringSubviewToFront(logoImageView)
        bgView.layer.cornerRadius = 10.0
        bgView.clipsToBounds = false
        logoImageView.clipsToBounds = false
        studentButton.layer.cornerRadius = 6.0
        adminButton.layer.cornerRadius = 6.0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            
            let orientation = UIDevice.current.orientation
            if let imageView = self.bgImageView.viewWithTag(999) as? UIImageView {
                if orientation == .portrait {
                    if let backgroundImage = UIImage(named: "USW_bg") {
                        imageView.image = backgroundImage
                    }
                    self.bgViewBottom.constant = 58.0
                    self.borderLabelTop.constant = 32.0
                    self.borderLabelBottom.constant = 32.0
                    self.logoImageWidth.constant = 167.0
                    self.logoImageHeight.constant = 167.0
                    self.logoViewTopConstraint.constant = -83.0
                    self.welcomeLabelTop.constant = 23.0
                }
                else {
                    if let backgroundImage = UIImage(named: "USW_Landscape") {
                        imageView.image = backgroundImage
                    }
                    self.bgViewBottom.constant = 8.0
                    self.borderLabelTop.constant = 4.0
                    self.borderLabelBottom.constant = 4.0
                    self.logoImageWidth.constant = 120.0
                    self.logoImageHeight.constant = 120.0
                    self.logoViewTopConstraint.constant = -50.0
                    self.welcomeLabelTop.constant = 0.0
                    
                }
            }
            self.view.layoutIfNeeded()

        }, completion: {
            _ in
        })

    }

    @IBAction func adminPortalClicked(_ sender: Any) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "UniProtalAdminPinController") as! UniProtalAdminPinController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func studentPortalClicked(_ sender: Any) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "UniPortalController") as! UniPortalController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
