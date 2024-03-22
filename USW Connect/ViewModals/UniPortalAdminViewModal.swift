//
//  UniPortalAdminViewModal.swift
//  USW Connect
//
//  Created by ekincare on 16/03/24.
//

import Foundation
import UIKit

class UniPortalAdminViewModal  {
    
    var dataArray = [UniPortalAdminCellData]()
    
    var processedAreas = Set<String>()
    
    func checkInternetWhileSubmit(controller:UIViewController) -> Bool {
        if CheckInternet.Connection() {
            return true
        }else {
            showAlert(controller: controller, message: "To Delete, please ensure your device is connected to the internet.", title: "Internet Connection Required")
            return false
        }
    }
    
    func showAlert(controller:UIViewController,message:String,title:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    func createDataArray(completionHandler:@escaping() -> (Void)) {
        ServiceHelper.fetchResponseFromApi { response in
            self.dataArray.removeAll()
            self.processedAreas.removeAll()
            for data in response {
                if !self.processedAreas.contains(data.getStringValue(key: "subject_area")) {
                    var cellData = UniPortalAdminCellData()
                    cellData.header = data.getStringValue(key: "subject_area")
                    cellData.cellType = .header
                    self.dataArray.append(cellData)
                }
                
                let header = data.getStringValue(key: "subject_area")
                
                if !self.processedAreas.contains(header) {
                    for areas in response {
                        if areas.getStringValue(key: "subject_area") == header {
                            var infoCellData = UniPortalAdminCellData()
                            infoCellData.data = areas
                            infoCellData.cellType = .info
                            self.dataArray.append(infoCellData)
                        }
                    }
                    self.processedAreas.insert(header)
                }
            }
            completionHandler()
        }
    }
}

struct UniPortalAdminCellData {
    var header = ""
    var data = [String:Any]()
    var cellType = uniportalAdminTypes.none
}

enum uniportalAdminTypes {
    case header
    case info
    case none
}
