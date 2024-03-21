//
//  UniPortalViewModal.swift
//  USW Connect
//
//  Created by ekincare on 11/03/24.
//

import Foundation
import UIKit
import CoreLocation

class UniPortalViewModal {
    
    var dataArray = [UniPortalCellData]()
    
    let userDefaults = UserDefaults.standard
    
    let dataArrayKey = "dataArrayKey"
    
    var postCode = ""
    
    func createDataArray() {
        dataArray.removeAll()
        var cellData = UniPortalCellData()
        cellData.title = "User Registration Form"
        cellData.cellTypes = .header
        dataArray.append(cellData)
        
        cellData.title = "Full Name"
        cellData.cellTypes = .fullName
        cellData.placeHolder = "Enter your full name"
        dataArray.append(cellData)
        
        cellData.title = "Date of birth"
        cellData.data = ""
        cellData.placeHolder = "Select your date of birth"
        cellData.cellTypes = .dateOfBirth
        dataArray.append(cellData)
        
        cellData.title = "Email"
        cellData.data = ""
        cellData.placeHolder = "Enter your email"
        cellData.cellTypes = .email
        dataArray.append(cellData)
        
        cellData.title = "Area of intrests"
        cellData.data = ""
        cellData.placeHolder = "Select your area of intrest"
        cellData.cellTypes = .areaOfIntrests
        dataArray.append(cellData)
        
        cellData.title = "Do you agree to marketing updates?"
        cellData.data = "No"
        cellData.cellTypes = .marketingCheck
        dataArray.append(cellData)
        
        cellData.title = "Do you want correspondence in Welsh?"
        cellData.data = "No"
        cellData.cellTypes = .correspondingCheck
        dataArray.append(cellData)
        
    }
    
    func showAlertsBasedOnType(type:FormTypes,controller:UIViewController) {
        switch type {
            case .fullName:
            showAlert(controller: controller, message: "Please fill the full name to proceed", title: "Missing information")
            break
        case .dateOfBirth:
            showAlert(controller: controller, message: "Please fill the date of birth to proceed", title: "Missing information")
            break
        case .email:
            showAlert(controller: controller, message: "Please fill the valid email to proceed", title: "Missing information")
            break
        case .areaOfIntrests:
            showAlert(controller: controller, message: "Please fill the area of intrests to proceed", title: "Missing information")
            break
        default:
            break
        }
    }
    
    func checkIsAllFieldsFilled(controller:UIViewController) -> Bool {
        for data in dataArray {
            switch data.cellTypes {
            case .fullName :
                if data.data.isEmpty {
                    showAlertsBasedOnType(type: .fullName, controller: controller)
                    return false
                }
            case .dateOfBirth :
                if data.data.isEmpty {
                    showAlertsBasedOnType(type: .dateOfBirth, controller: controller)
                    return false
                }
            case .email :
                if data.data.isEmpty || !checkEmailIsValid(){
                    showAlertsBasedOnType(type: .email, controller: controller)
                    return false
                }
            case .areaOfIntrests:
                if data.data.isEmpty {
                    showAlertsBasedOnType(type: .areaOfIntrests, controller: controller)
                    return false
                }
            default:
                break 
            }
        }
        return true
    }
    
    func checkEmailIsValid() -> Bool {
        let fetchEmail = dataArray.filter({$0.cellTypes == .email})
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: fetchEmail.first?.data ?? "")
    }
    
    func showAlert(controller:UIViewController,message:String,title:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    func storeDataInLocalDataBase() {
        userDefaults.set(convertDataArrayForApi(), forKey: dataArrayKey)
    }
    
    func checkInternetWhileSubmit(controller:UIViewController) -> Bool {
        if CheckInternet.Connection() {
            return true
        }else {
            showAlert(controller: controller, message: "Please connect the internet to submit", title: "Internet error")
            return false
        }
    }
    
    func convertDataArrayForApi() -> [String:Any]{
        let convertedArray = [
            "full_name" : dataArray.filter({$0.cellTypes == .fullName}).first?.data ?? "",
            "date_of_birth" : dataArray.filter({$0.cellTypes == .dateOfBirth}).first?.data ?? "",
            "email": dataArray.filter({$0.cellTypes == .email}).first?.data ?? "",
            "subject_area" : dataArray.filter({$0.cellTypes == .areaOfIntrests}).first?.data ?? "",
            "gps_location" : postCode,
            "marketing_updates" :(dataArray.filter({$0.cellTypes == .marketingCheck}).first?.data ?? "") == "Yes" ? true : false ,
            "correspondence_in_welsh" :(dataArray.filter({$0.cellTypes == .correspondingCheck}).first?.data ?? "") == "Yes" ? true : false
        ] as [String:Any]
        return convertedArray
    }
    
    
}

struct UniPortalCellData  {
    var title = ""
    var data = ""
    var placeHolder = ""
    var cellTypes = FormTypes.none
    
}

enum FormTypes {
    case header
    case fullName
    case dateOfBirth
    case areaOfIntrests
    case email
    case marketingCheck
    case correspondingCheck
    case footer
    case none
}
