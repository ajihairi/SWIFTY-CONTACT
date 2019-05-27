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
    var isbase64: Bool?
    var indexPath: IndexPath?
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
    
    private func setupAvatar(){
        if let dataDecoded: Data = Data(base64Encoded: currentContact!.photo, options: .ignoreUnknownCharacters) {
            let decodedImg = UIImage(data: dataDecoded)
            let newSizeImg = decodedImg?.resizeWithWidth(width: 1000)
            let imgData:Data = newSizeImg?.jpegData(compressionQuality: 1.0) ?? Data(count: 10)
            let decompressedImg = UIImage(data: imgData)
            let decompressedData = decompressedImg?.pngData()
            let dataForRender = UIImage(data: decompressedData ?? Data(capacity: 10))
            contactImage.image = dataForRender != nil ? dataForRender : UIImage(named: "defaultAvatar")
            contactImage.contentMode = .scaleToFill
        } else {
            print("not base64")
            isbase64 = false
        }
    }
    
    private func deleteContactById(id: String, indexPath: IndexPath){
        progressBarDisplayer(deleteExistingContactIndicatorMsg, removing: false, superView: self.view)
        ContactService.deleteExistingContact(baseUrl, id: id, httpMethod: "DELETE") { (error, result, resultData) in
            DispatchQueue.main.async {
                progressBarDisplayer("", removing: true, superView: self.view)
                
                if (error == nil && result == true){
                    allContacts.removeAtIndex(index: indexPath.row)
                } else {
                    let responseString = String(data: resultData!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    print(responseString)
                    self.present(createAlertWithOnlyOkay(title: "Error", msg: responseString ?? errorMessage, style: .alert, callBackSelf: self), animated: true, completion: nil)
                }
            }
        }
    }
    
    func setUpExistingContactDetails(contact:ContactField) {
        self.title = contact.firstName + " " + contact.LastName
        firstNameField.text = contact.firstName
        lastNameField.text = contact.LastName
        ageField.text = String(contact.age)
        if contact.photo.count < 15 || contactImage.image == UIImage(named: "defaultAvatar") {
            self.contactImage.downloaded(from: contact.photo)
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
        }
        setupAvatar()
        self.contactImage.contentMode = .scaleAspectFill
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
            let compressedImg = UIImage(data: imageData)!
            let compressedData: Data = compressedImg.pngData()!
            contactImage.image = UIImage(data: compressedData)
            let strBase64 = compressedData.base64EncodedString(options: .lineLength64Characters)
            base64Img = strBase64
            
           
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func trashAction(_ sender: Any) {
        deleteContactById(id: self.contactID!, indexPath: self.indexPath!)
    }
    @IBAction func saveAction(_ sender: Any) {
        saveContact()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            firstNameField.becomeFirstResponder()
        case 2:
            lastNameField.becomeFirstResponder()
        case 3:
            ageField.becomeFirstResponder()
        case 4:
            addImageOutlet.resignFirstResponder()
            
        default:
            textField.resignFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func textfieddidchanged(_ sender: UITextField) {
        if (sender as AnyObject).tag == 1 {
            self.title = (sender).text
        }
        
        guard firstNameField.text != "" && lastNameField.text != ""  && ageField.text != "" else {
            self.saveOutlet.isEnabled = false
            return
        }
        
        self.saveOutlet.isEnabled = true
        
        if let temp = currentContact{
            
            guard  temp.firstName != firstNameField.text || temp.LastName != lastNameField.text || String(temp.age) != ageField.text || temp.photo != "put photo"
                else {
                self.saveOutlet.isEnabled = false
                return
            }
            self.saveOutlet.isEnabled = true
        }
    }
    
    private func saveContact() {
        if let _ = currentContact, let tempId = contactID{
            progressBarDisplayer(updateExistingContactIndicatorMsg, removing: false, superView: self.view)
            let conts = postContact(firstName: firstNameField.text, lastName: lastNameField.text, age:(ageField.text! as NSString).integerValue, photo: base64Img != "" ? base64Img : currentContact?.photo)
            ContactService.updateExistingContact(baseUrl, id: tempId, contact: conts, httpMethod: "PUT", getBack: { [weak weakSelf = self] (error, result, resultData) in
                DispatchQueue.main.async {
                    progressBarDisplayer("", removing: true, superView: self.view)
                    if (error == nil && result == true){
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: resultData!, options: []) as! NSDictionary
                            print("ini json update rsult",jsonResult)
//                            let dictId = jsonResult["id"] as? [String:Any]
                            let cont = ContactField(id: "", firstName: conts.firstName, LastName: conts.lastName, age: conts.age, photo: conts.photo)

                                for i in (0..<allContacts.array.count){
//                                    if allContacts[i].value(forKey: "id") as! String == (weakSelf?.contactID!)! as String{
                                        let tempDict = ["object":cont]
                                        allContacts.setObject(obj: tempDict as AnyObject, index: i)
//                                        //allEmployees[i] = tempDict as AnyObject
//                                        break
//                                    }
                                }
                            _ = weakSelf?.navigationController?.popViewController(animated: true)

                        } catch let error as NSError {
                            print(error.localizedDescription)
                            self.present(createAlertWithOnlyOkay(title: "Error", msg: error.localizedDescription, style: .alert, callBackSelf: self), animated: true) {
                            }
                        }
                    }
                    else
                    {
                        print(error?.localizedDescription ?? errorMessage)
                        let responseString = String(data: resultData!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                        print(responseString)
                        self.present(createAlertWithOnlyOkay(title: "Error", msg: (responseString ?? errorMessage), style: .alert, callBackSelf: self), animated: true) {
                        }
                    }
                }
            })
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
                        let responseString = String(data: resultData!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                        print(responseString)
                        self.present(createAlertWithOnlyOkay(title: "Error", msg: responseString ?? errorMessage, style: .alert, callBackSelf: self), animated: true) {
                        }
                    }
                }
            }
        }
    }

}
