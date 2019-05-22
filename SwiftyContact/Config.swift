//
//  Config.swift
//  SwiftyContact
//
//  Created by ajihairi on 18/05/19.
//  Copyright © 2019 hamzhya. All rights reserved.
//

import Foundation
import UIKit

let baseUrlString = "https://simple-contact-crud.herokuapp.com/"
let path = "contact"
let databaseName = "iosdemo" //Enter your database name
let section = "collections"
let collectionName = "employee" // Enter your collection name
let yourApiKey = "" // Enter yout mlab account api key
let apiKey = "apiKey=\(yourApiKey)"
let headers = [
    "Content-Type": "application/json"
]

let timeout = 100 as TimeInterval

let errorMessage = "Something went wrong, Please try again"

var baseUrlWithKey:URL = URL(string: baseUrlString + path )!

var baseUrl:URL = URL(string: baseUrlString + path + "/")!

let appDelegate = UIApplication.shared.delegate as! AppDelegate

//var allEmployees = [AnyObject]()

var allContacts = AllContactStruct<AnyObject>()


let allContactIndicatorMsg = "Fetching..."

let createNewContactIndicatorMsg = "Creating..."

let updateExistingContactIndicatorMsg = "Updating..."

let deleteExistingContactIndicatorMsg = "Deleting..."

let context = appDelegate.persistentContainer.viewContext

