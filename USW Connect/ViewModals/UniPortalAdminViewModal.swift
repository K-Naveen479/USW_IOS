//
//  UniPortalAdminViewModal.swift
//  USW Connect
//
//  Created by ekincare on 16/03/24.
//

import Foundation

class UniPortalAdminViewModal  {
    
    var dataArray = [UniPortalAdminCellData]()
    
    var processedAreas = Set<String>()
    
    var DummyData = [["Full Name" : "Naveen",
                      "Date of birth" : "16",
                      "Email": "naveenk@ekincare.com",
                      "Area of intrests" : "Engineering",
                      "Postcode" : "12345",
                      "Marketing Updated" :"Yes",
                      "Corresponding Updated" :"Yes"
                     ],["Full Name" : "Naveen",
                        "Date of birth" : "16",
                        "Email": "naveenk@ekincare.com",
                        "Area of intrests" : "Engineering",
                        "Postcode" : "12345",
                        "Marketing Updated" :"Yes",
                        "Corresponding Updated" :"Yes"]] as [[String:Any]]
    
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
