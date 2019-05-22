//
//  DetailViewController.swift
//  SwiftyContact
//
//  Created by ajihairi on 18/05/19.
//  Copyright © 2019 hamzhya. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate   {
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var saveOutlet: UIBarButtonItem!
    @IBOutlet weak var addImageOutlet: UIButton!
    
    var imagePicker = UIImagePickerController()
    var base64Img: String?
    var currentContact: ContactField?
    var contactID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let temp = currentContact{
            setUpExistingContactDetails(contact: temp)
        }
        else{
            self.title = "New Contact"
        }
        contactImage.setRounded()
        saveOutlet.isEnabled = false
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func setUpExistingContactDetails(contact:ContactField) {
        self.title = contact.firstName + " " + contact.LastName
        firstNameField.text = contact.firstName
        lastNameField.text = contact.LastName
        ageField.text = String(contact.age)
        if contact.photo.count < 5 {
            let label = contact.firstName.count > 0
                ? contact.firstName.prefix(1).uppercased() + contact.LastName.prefix(1).uppercased()
                : "#"
            
            self.contactImage.setImage(string: label,
                                           color: UIColor.colorHash(name: label),
                                           circular: true,
                                           stroke: false,
                                           textAttributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Medium.ttf", size: 32) ?? UIFont.systemFont(ofSize: 120),NSAttributedString.Key.foregroundColor : UIColor.white ])
        } else {
            self.contactImage.downloaded(from: contact.photo)
            self.contactImage.contentMode = .scaleAspectFill
        }
    }
    
    @IBAction func addImageAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             contactImage.image = pickedImage
            contactImage.contentMode = .scaleAspectFill
            let resizeImg = pickedImage.resizeWithWidth(width: 50)!
            let imageData:Data = resizeImg.jpegData(compressionQuality: 0.5)!
//            let compressedImg = UIImage(data: imageData)
//            contactImage.image = compressedImg
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            base64Img = strBase64
            print(base64Img)
            
           
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func trashAction(_ sender: Any) {
    }
    @IBAction func saveAction(_ sender: Any) {
        saveContact()
    }
    @IBAction func textfieddidchanged(_ sender: UITextField) {
        if (sender as AnyObject).tag == 1 {
            self.title = (sender).text
        }
        
        guard firstNameField.text != "" && lastNameField.text != ""  && ageField.text != "" else {
            self.saveOutlet.isEnabled = true
            return
        }
        
        self.saveOutlet.isEnabled = true
        
        if let temp = currentContact{
            
            guard  temp.firstName != firstNameField.text || temp.LastName != lastNameField.text || String(temp.age) != ageField.text || temp.photo != "put photo"
                else {
                self.saveOutlet.isEnabled = true
                return
            }
            self.saveOutlet.isEnabled = true
        }
    }
    
    private func saveContact() {
        if let _ = currentContact, let tempId = contactID{
//            progressBarDisplayer(updateExistingContactIndicatorMsg, removing: false, superView: self.view)
//            let conts = ContactField(id: "", firstName: firstNameField.text, LastName: lastNameField.text, age:(ageField.text! as NSString).integerValue, photo: "isi fotoooo")
//            ContactService.updateExistingContact(baseUrl, id: tempId, contact: conts, httpMethod: "PUT", getBack: { [weak weakSelf = self] (error, result, resultData) in
//                DispatchQueue.main.async {
//                    progressBarDisplayer("", removing: true, superView: self.view)
//                    if (error == nil && result == true){
//                        do {
//                            let jsonResult = try JSONSerialization.jsonObject(with: resultData!, options: []) as! NSDictionary
//                            print(jsonResult)
//                            let dictId = jsonResult["id"] as? [String:Any]
////                                let cont = Employee(name: jsonResult["name"] as! String?, contactNumber: jsonResult["contactNumber"] as! Int?, salary: jsonResult["salary"] as! Int?, designation: jsonResult["designation"] as! String?)
//                            let cont = ContactField(id: <#T##String?#>, firstName: <#T##String?#>, LastName: <#T##String?#>, age: <#T##Int?#>, photo: <#T##String?#>)
//
//                                for i in (0..<allEmployees.array.count){
//                                    if allEmployees[i].value(forKey: "id") as! String == (weakSelf?.employeeId!)! as String{
//                                        let tempDict = ["id":dictId["$oid"],"object":emp]
//                                        allEmployees.setObject(obj: tempDict as AnyObject, index: i)
//                                        //allEmployees[i] = tempDict as AnyObject
//                                        break
//                                    }
//                                }
//                            _ = weakSelf?.navigationController?.popViewController(animated: true)
//
//                        } catch let error as NSError {
//                            print(error.localizedDescription)
//                            self.present(createAlertWithOnlyOkay(title: "Error", msg: error.localizedDescription, style: .alert, callBackSelf: self), animated: true) {
//                            }
//                        }
//                    }
//                    else
//                    {
//                        print(error?.localizedDescription ?? errorMessage)
//                        self.present(createAlertWithOnlyOkay(title: "Error", msg: (error?.localizedDescription ?? errorMessage), style: .alert, callBackSelf: self), animated: true) {
//                        }
//                    }
//                }
//            })
        }
        else{
            progressBarDisplayer(createNewContactIndicatorMsg, removing: false, superView: self.view)
            let cont1 = postContact(firstName: firstNameField.text, lastName: lastNameField.text, age: Int(ageField.text!), photo: base64Img ?? "N/A")
            ContactService.createNewContact(baseUrlWithKey, contact: cont1, httpMethod: "POST") { [weak weakSelf = self] (error, result, resultData) -> () in
                DispatchQueue.main.async {
                    progressBarDisplayer("", removing: true, superView: self.view)
                }
                
                if (error == nil && result == true){
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: resultData!, options: []) as! NSDictionary
                        print(jsonResult.count)
                        let cont = ContactField(id: "", firstName: cont1.firstName, LastName: cont1.lastName, age: cont1.age, photo: cont1.photo)
                            
                            let tempDict = ["object":cont]
                            allContacts.append(newElement: tempDict as AnyObject)
                        DispatchQueue.main.async {
                            _ = weakSelf?.navigationController?.popViewController(animated: true)
                        }
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            self.present(createAlertWithOnlyOkay(title: "Error", msg: error.localizedDescription, style: .alert, callBackSelf: self), animated: true) {
                            }
                        }
                    }
                }
                else
                {
                    print(error?.localizedDescription ?? errorMessage)
                    DispatchQueue.main.async {
                        self.present(createAlertWithOnlyOkay(title: "Error", msg: error?.localizedDescription ?? errorMessage, style: .alert, callBackSelf: self), animated: true) {
                        }
                    }
                }
            }
        }
    }

}
