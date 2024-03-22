//
//  NetworkMonitoring.swift
//  USW Connect
//
//  Created by ekincare on 15/03/24.
//

import Foundation
import SystemConfiguration

public class CheckInternet{
    
    class func Connection() -> Bool{
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

public class ServiceHelper {
    class func fetchResponseFromApi(completionHandler:@escaping([[String:Any]]) -> (Void)) {
        guard let url = URL(string: "http://localhost:3000/prospects") else {
            print("Invalid URL")
            return
        }
        
        // Create a URLSession object
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            // Check for any errors
            if let error = error {
                completionHandler([["Error" : error.localizedDescription]])
                return
            }
            
            // Check if response contains data
            guard let responseData = data else {
                print("No data received")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String:Any]] {
                    completionHandler(json)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    class func postResponseToApi(postData:[String: Any],completionHandler:@escaping (Bool,[String:Any]) -> (Void)) {
        // API endpoint URL
        guard let url = URL(string: "http://localhost:3000/prospects") else {
            print("Invalid URL")
            return
        }
        
        // Create URL request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error encoding POST data: \(error)")
            return
        }
        
        // Create a URLSession object
        let session = URLSession.shared
        
        // Create a data task for POST request
        let task = session.dataTask(with: request) { (data, response, error) in
            // Check for any errors
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Check if response contains data
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("No HTTP response")
                    return
                }
                
                // Get the status code
                let statusCode = httpResponse.statusCode
                print("Status Code: \(statusCode)")
            
            // Check if response contains data
            guard let responseData = data else {
                print("No data received")
                return
            }
            
            do {
                // Try to decode JSON data
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:Any] {
                    if statusCode == 200 {
                        completionHandler(true,json)
                    }else {
                        completionHandler(false,json)
                    }
                }
                
            } catch {
                print("Error decoding POST JSON: \(error)")
            }
        }
        
        // Start the data task
        task.resume()
    }
    
    class func deleteDataFromDatabase(id:Int,completionHandler:@escaping(Bool) -> (Void)) {
        guard let url = URL(string: "http://localhost:3000/prospects/\(id)") else {
            print("Invalid URL")
            return
        }
        
        // Create a URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // Create a URLSession object
        let session = URLSession.shared
        
        // Create a data task for DELETE request
        let task = session.dataTask(with: request) { (data, response, error) in
            // Check for any errors
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Check if response contains data
            guard let _ = data else {
                print("No data received")
                return
            }
            
            // Handle response here
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
                completionHandler(true)
                // Process response based on status code
            }
        }
        
        // Start the data task
        task.resume()
    }
}

