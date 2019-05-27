//
//  ContactService.swift
//  SwiftyContact
//
//  Created by ajihairi on 18/05/19.
//  Copyright © 2019 hamzhya. All rights reserved.
//

import Foundation
import Security

class ContactService {
    
    class func getAllContacts(_ url:URL!, getBack: @escaping (NSError?, Bool, Data?) -> ()){
        var request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: timeout)
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let task:URLSessionDataTask = session.dataTask(with: request as URLRequest) { Data,response,error in
            guard error == nil && Data != nil else {
                print("error=\(String(describing: error))")
                getBack (error as NSError?, false, nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                getBack (error as NSError?, false, Data)
            }
            else{
                getBack (nil,true,Data!)
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    class func createNewContact(_ url:URL,contact:postContact,httpMethod:NSString, getBack: @escaping (_ error:NSError?,_ result:Bool,_ resultData:Data?) -> ()){
        
        var request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: timeout)
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        request.httpMethod = httpMethod as String
        
        
        if let json = contact.toJSON(){
            if let data = json.data(using: .utf8){
//                print("ini JSON", json)
                request.httpBody = data
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task:URLSessionDataTask = session.dataTask(with: request as URLRequest) { Data,response,error in
                    guard error == nil && Data != nil else {
                        print("error=\(String(describing: error))")
                        getBack (error as NSError?, false, nil)
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 201 {
                        print("statusCode should be 201, but is \(httpStatus.statusCode)")
                        print("response = \(String(describing: response))")
                        getBack (error as NSError?, false, Data)
                    }
                        
                    else{
                        
                        //let responseString = NSString(data: Data!, encoding: String.Encoding.utf8.rawValue)
                        //print("responseString = \(responseString!)")
                        getBack (nil,true,Data!)
                    }
                }
                task.resume()
                session.finishTasksAndInvalidate()
            }
        }
        
    }
    
    class func updateExistingContact(_ url:URL,id:String, contact:postContact,httpMethod:NSString, getBack: @escaping (_ error:NSError?,_ result:Bool,_ resultData:Data?) -> ()){
        
        let strUrl = url.absoluteString + id
        
        var request = URLRequest(url: URL(string: strUrl)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: timeout)
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        request.httpMethod = httpMethod as String
        
        if let json = contact.toJSON(){
            print(json)
            if let data = json.data(using: .utf8){
                request.httpBody = data
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task:URLSessionDataTask = session.dataTask(with: request as URLRequest) { Data,response,error in
                    guard error == nil && Data != nil else {
                        print("error=\(String(describing: error))")
                        getBack (error as NSError?, false, nil)
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 201 {
                        print("statusCode should be 201, but is \(httpStatus.statusCode)")
                        print("response = \(String(describing: response))")
                        getBack (error as NSError?, false, Data)
                    }
                    else {
                        
                        // let responseString = NSString(data: Data!, encoding: String.Encoding.utf8.rawValue)
                        // print("responseString = \(responseString!)")
                        getBack (nil,true,Data!)
                    }
                    
                }
                task.resume()
                session.finishTasksAndInvalidate()
            }
        }
    }
    
    class func deleteExistingContact(_ url:URL,id:String,httpMethod:NSString, getBack: @escaping (_ error:NSError?,_ result:Bool,_ resultData:Data?) -> ()){
        
        let strUrl = url.absoluteString + id
        print(strUrl)
        
        var request = URLRequest(url: URL(string: strUrl)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: timeout)
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        request.httpMethod = httpMethod as String
        
        let task:URLSessionDataTask = session.dataTask(with: request as URLRequest) { Data,response,error in
            guard error == nil && Data != nil else {
                print("error=\(String(describing: error))")
                getBack (error as NSError?, false, nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 202 {
                print("statusCode should be 202, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                getBack (error as NSError?, false, Data)
            }
            else {
//                 let responseString = NSString(data: Data!, encoding: String.Encoding.utf8.rawValue)
//                 print("responseString = \(responseString!)")
                getBack (nil,true,Data!)
            }
            
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
