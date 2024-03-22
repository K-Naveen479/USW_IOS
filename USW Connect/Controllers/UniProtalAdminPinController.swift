//
//  UniProtalAdminPinController.swift
//  USW Connect
//
//  Created by ekincare on 20/03/24.
//

import UIKit

class UniProtalAdminPinController: UIViewController {
    
    let adminPins = ["1234","1456","2345"]
    
    let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var passcodeHeader: UILabel!
    @IBOutlet weak var txtField: UITextField!
    
    @IBOutlet weak var passcodeHintLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        navigationController?.isNavigationBarHidden = true
    }
    
    func setUpViews() {
        addDoneButtonToToolBar()
        passcodeHeader.setText(text: "PASSCODE", withKerning: 1.0)
        txtField.keyboardType = .numberPad
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 164/255, green: 176/255, blue: 204/255, alpha: 1.0),
            NSAttributedString.Key.font : UIFont(name: "Figtree-SemiBold", size: 16)! // Note the !
        ]

        txtField.attributedPlaceholder = NSAttributedString(string: "Enter your passcode", attributes:attributes)
        submitButton.layer.cornerRadius = 6.0
    }
    
    func addDoneButtonToToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let additonalSpace = UIBarButtonItem(systemItem: .flexibleSpace, primaryAction: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonClicked))
        toolbar.setItems([additonalSpace,doneButton], animated: false)
        
        txtField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonClicked() {
        txtField.resignFirstResponder()
    }
    

    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
   
    @IBAction func submitButtonClicked(_ sender: Any) {
        if adminPins.contains(txtField.text ?? "") {
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "UniPortalAdminController") as! UniPortalAdminController
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            showAlert()
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Missing", message: "Please provide proper pin to access admin portal", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
