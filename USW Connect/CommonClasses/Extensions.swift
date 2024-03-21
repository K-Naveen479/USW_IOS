//
//  Extensions.swift
//  USW Connect
//
//  Created by ekincare on 15/03/24.
//

import Foundation
import UIKit
import CoreLocation

let colore5e8f0 = hexStringToUIColor("E5E8F0")
let color0E9347 = hexStringToUIColor("0E9347")
let colorCD173C = hexStringToUIColor("CD173C")


func hexStringToUIColor(_ hex: String , alpha:Float? = 1.0) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(alpha!)
    )
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
    
}

extension Date {
    func dateString(_ format: String = "MMM-dd-yyyy, hh:mm a") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocale()
        dateFormatter.timeZone      =   TimeZone.current
        dateFormatter.dateFormat    =   format
        return dateFormatter.string(from: self)
    }
}

extension DateFormatter {
    
    func setLocale() {
        self.locale = Locale(identifier: "en_US_POSIX")
    }
    
}

extension UILabel {
    func setText(text: String, withKerning kerning: Double) {
        self.attributedText = NSAttributedString(string: text, attributes: kerningAttribute(kerning: kerning))
    }
    
    func kerningAttribute(kerning: Double) -> [NSAttributedString.Key: AnyObject] {
        return [NSAttributedString.Key.kern: kerning as AnyObject]
    }
}


extension UniPortalController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        print("Location\(location)")
        getAddressFromCoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { postcode in
            self.viewModal.postCode = postcode ?? ""
        }
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied:
            manager.requestWhenInUseAuthorization()
            showAlertForLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .restricted:
            showAlertForLocation()
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func showAlertForLocation() {
        let alertController = UIAlertController(title: "Location Services Disabled", message: "Please enable location services in Settings.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        
    }
    
    func getAddressFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }
            
            var addressComponents: [String] = []
            
            if let name = placemark.name {
                addressComponents.append(name)
            }
            
            if let thoroughfare = placemark.thoroughfare {
                addressComponents.append(thoroughfare)
            }
            
            if let subThoroughfare = placemark.subThoroughfare {
                addressComponents.append(subThoroughfare)
            }
            
            if let locality = placemark.locality {
                addressComponents.append(locality)
            }
            
            if let administrativeArea = placemark.administrativeArea {
                addressComponents.append(administrativeArea)
            }
            
            if let postalCode = placemark.postalCode {
                addressComponents.append(postalCode)
            }
            
            if let country = placemark.country {
                addressComponents.append(country)
            }
            
            let fullAddress = addressComponents.joined(separator: ", ")
            completion(fullAddress)
        }
    }
}

extension Dictionary {
    func getStringValue(key:Key,defaultValue:String = "") -> String {
        var id = defaultValue
        if let idString = self[key] as? String {
            id = idString
        }
        else if let idInt = self[key] as? Int {
            id = "\(idInt)"
        }
        else if let idInt = self[key] as? Double {
            id = "\(idInt)"
        }
        return id
    }
    
    func getBoolValue(key:Key,defaultValue:Bool = false) -> Bool {
        var boolValue = defaultValue
        if let idString = self[key] as? Bool {
            boolValue = idString
        }
        else if let idInt = self[key] as? Int {
            boolValue = idInt == 0 ? false : true
        }
        return boolValue
    }
}
