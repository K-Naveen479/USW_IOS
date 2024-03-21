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
    
    let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        addBackgroundImage()
        bgView.bringSubviewToFront(logoImageView)
        bgView.layer.cornerRadius = 10.0
        bgView.clipsToBounds = false
        logoImageView.clipsToBounds = false
        studentButton.layer.cornerRadius = 6.0
        adminButton.layer.cornerRadius = 6.0
    }
    
    func addBackgroundImage() {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true // Ensures the image doesn't overflow its bounds
        
        // Replace "yourImageName" with the name of your image asset
        if let backgroundImage = UIImage(named: "USW_bg") {
            imageView.image = backgroundImage
        }
        
        // Add the UIImageView as a subview to the view
        self.mainView.addSubview(imageView)
        
        // Ensure the image view is behind all other views
        self.mainView.sendSubviewToBack(imageView)
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
