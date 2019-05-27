//
//  AllContactStruct.swift
//  SwiftyContact
//
//  Created by ajihairi on 18/05/19.
//  Copyright © 2019 hamzhya. All rights reserved.
//
import Foundation
import CoreData


struct AllContactStruct<T> {
    var array: [T] = []
    
    mutating func append(newElement: T) {
        saveIt(element:newElement)
        self.array.append(newElement)
        print("Element added")
    }
    
    mutating func removeAtIndex(index: Int) {
        print("Removed object \(self.array[index]) at index \(index)")
        removeIt(element: self.array[index])
        self.array.remove(at: index)
    }
    
    mutating func removeAll() {
        print("Removed all")
        removeAllData()
        if self.array.count > 0{
            self.array.removeAll()
        }
        //removeIt(element:)
    }
    
    mutating func getObject(i:Int)->T{
        return array[i]
    }
    
    mutating func setObject(obj:T, index i:Int){
        updateIt(element: obj)
        array[i] = obj
    }
    
    mutating func count()->Int{
        return self.array.count
    }
    
    mutating func getAll(){
        if array.count > 0 {
            self.array.removeAll()
        }
        do {
            let result = try context.fetch(ContactData.fetchRequest())
            for contactData in result as! [ContactData]{
                let tmpage = Int(contactData.age)
                let cont = ContactField(id: contactData.id, firstName: contactData.firstName, LastName: contactData.lastName, age: tmpage, photo: contactData.photo)
//                let tmpDict = ["id":contactData.id ?? "", "object":cont] as [String : Any]
                let tmpDict = ["object":cont] as [String : Any]
                self.array.append(tmpDict as! T)
            }
            
        } catch  {
            print(error)
        }
    }
    
    func encodeIt(element:T)->T{
        return element
    }
    
    func decodeIt(element:T)->T{
        return element
    }
    
    func saveIt(element:T){
        let conts = ContactData(context:context)
        if let tempDict = element as? Dictionary<String, AnyObject>{
            conts.id = tempDict["id"] as! String?
            if let tempContact = tempDict["object"] as? ContactField{
                conts.id = tempContact.id
                conts.firstName = tempContact.firstName
                conts.lastName = tempContact.LastName
                conts.age = Int32(tempContact.age)
                conts.photo = tempContact.photo
                appDelegate.saveContext()
            }
        }
    }
    
    func updateIt(element:T){
        if let tempDict = element as? Dictionary<String, AnyObject>{
//            let id = tempDict["id"] as! String
            let fetchRequest: NSFetchRequest<ContactData> = ContactData.fetchRequest()
//            fetchRequest.predicate = NSPredicate.init(format: "",id)
            if let result = try? context.fetch(fetchRequest) {
                for object in result {
                    if let tempContact = tempDict["object"] as? ContactField{
                        object.firstName = tempContact.firstName
                        object.lastName = tempContact.LastName
                        object.age = Int32(tempContact.age)
                        object.photo = tempContact.photo
                        appDelegate.saveContext()
                    }
                }
            }
        }
    }
    
    func removeIt(element:T){
        if let tempDict = element as? Dictionary<String, AnyObject>{
            let id = tempDict["id"] as! String
            let fetchRequest: NSFetchRequest<ContactData> = ContactData.fetchRequest()
            fetchRequest.predicate = NSPredicate.init(format: "",id)
            if let result = try? context.fetch(fetchRequest) {
                for object in result {
                    context.delete(object)
                    appDelegate.saveContext()
                }
            }
        }
    }
    
    func removeAllData() {
        do {
            let result = try context.fetch(ContactData.fetchRequest())
            for contsData in result as! [ContactData]{
                context.delete(contsData)
                appDelegate.saveContext()
            }
            
        } catch  {
            print(error)
        }
    }
    
    init() {
        //  getAll()
    }
    
    subscript(index: Int) -> T {
        set {
            print("Set object from \(self.array[index]) to \(newValue) at index \(index)")
            self.array[index] = newValue
        }
        get {
            return self.array[index]
        }
    }
}

