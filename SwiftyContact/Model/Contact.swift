//
//  Contact.swift
//  SwiftyContact
//
//  Created by ajihairi on 18/05/19.
//  Copyright © 2019 hamzhya. All rights reserved.
//

import Foundation

protocol JSONRepresentable {
    var JSONRepresentation: AnyObject { get }
}

protocol JSONSerializable: JSONRepresentable {
}

extension JSONSerializable {
    var JSONRepresentation: AnyObject {
        var representation = [String: AnyObject]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
            case let value as JSONRepresentable:
                representation[label] = value.JSONRepresentation
                
            case let value as NSObject:
                representation[label] = value
                
            default:
                break
            }
        }
        
        return representation as AnyObject
    }
}

extension JSONSerializable {
    func toJSON() -> String? {
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: [])
            return String(data: data, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "\\", with: "")
        } catch {
            return nil
        }
    }
}

struct Contact:JSONSerializable {
    var message: String!
    var data: [ContactField]!
    
}

struct ContactField:JSONSerializable {
    var id:String!
    var firstName:String!
    var LastName:String!
    var age:Int!
    var photo:String!
}

struct postContact: JSONSerializable {
    var firstName:String!
    var lastName:String!
    var age:Int!
    var photo:String!
}
