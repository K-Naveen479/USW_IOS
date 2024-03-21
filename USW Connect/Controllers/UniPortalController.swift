//
//  UniPortalController.swift
//  USW Connect
//
//  Created by ekincare on 11/03/24.
//

import UIKit
import CoreLocation

class UniPortalController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModal = UniPortalViewModal()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        navigationController?.isNavigationBarHidden = true
        registerTableViewCells()
        reuseDataArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if viewModal.checkIsAllFieldsFilled(controller: self) && viewModal.checkInternetWhileSubmit(controller: self) {
            ServiceHelper.postResponseToApi(postData: ["prospect":viewModal.convertDataArrayForApi()]) { done,response  in
                if done {
                    DispatchQueue.main.async {
                        self.reuseDataArray()
                        self.viewModal.storeDataInLocalDataBase()
                        self.viewModal.showAlert(controller: self, message: "Your details submitted to database",title: "Success")
                    }
                }else {
                    for (key,value) in response {
                        if let messageArray = value as? [Any], let message = messageArray.first as? String{
                            DispatchQueue.main.async {
                                self.viewModal.showAlert(controller: self, message: "\(key) \(message)", title: "Error")
                            }
                        } else if let message = value as? String {
                            DispatchQueue.main.async {
                                self.viewModal.showAlert(controller: self, message: "\(key) \(message)", title: "Error")
                            }
                        } else {
                            print("Invalid value type:", type(of: value))
                        }
                    }
                }
            }
        }
    }
    
    func registerTableViewCells() {
        tableView.register(UINib(nibName: "UniPortalFormCell", bundle: nil), forCellReuseIdentifier: "UniPortalFormCell")
        tableView.register(UINib(nibName: "UniPortalHeader", bundle: nil), forCellReuseIdentifier: "UniPortalHeader")
        tableView.register(UINib(nibName: "UniPortalSubmitCell", bundle: nil), forCellReuseIdentifier: "UniPortalSubmitCell")
        tableView.register(UINib(nibName: "UniPortalChecksCell", bundle: nil), forCellReuseIdentifier: "UniPortalChecksCell")
    }
    
    func reuseDataArray() {
        viewModal.createDataArray()
        tableView.reloadData()
    }

}

extension UniPortalController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = viewModal.dataArray[indexPath.row]
        switch rowData.cellTypes {
        case .fullName,.email,.dateOfBirth,.areaOfIntrests:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UniPortalFormCell", for: indexPath) as! UniPortalFormCell
            cell.delegate = self
            cell.indexRow = indexPath.row
            cell.cellType = rowData.cellTypes
            cell.setData(data: rowData)
            return cell
        case .marketingCheck,.correspondingCheck:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UniPortalChecksCell", for: indexPath) as! UniPortalChecksCell
            cell.checksLabel.text = rowData.title
            cell.indexpath = indexPath.row
            cell.delegate = self
            return cell
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UniPortalHeader", for: indexPath) as! UniPortalHeader
            return cell
        default :
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModal.dataArray.count
    }
}

extension UniPortalController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension UniPortalController: UniPortalChecksCellProtocol {
    func storeSwitchCondition(check: String,indexpath:Int) {
        viewModal.dataArray[indexpath].data = check
    }
}

extension UniPortalController: UniPortalFormCellProtocol {
    func storeUserFields(data: String, indexRow: Int) {
        viewModal.dataArray[indexRow].data = data
    }
}
