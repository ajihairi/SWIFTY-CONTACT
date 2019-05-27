//
//  ListTableViewController.swift
//  SwiftyContact
//
//  Created by ajihairi on 18/05/19.
//  Copyright © 2019 hamzhya. All rights reserved.
//

import UIKit


struct responseEndpoint: Decodable {
    let message: String
    let data: [Contactz]
}

struct Contactz:Decodable {
    var id:String!
    var firstName:String!
    var LastName:String!
    var age:Int!
    var photo:String!
    
}
class ListTableViewController: UITableViewController {
    
    @IBOutlet weak var refreshOutlet: UIRefreshControl!
    @IBOutlet weak var addOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshOutlet.addTarget(self, action: #selector(refreshAction(sender:)), for: .valueChanged)
        refreshOutlet.attributedTitle = NSAttributedString(string: "pull to refresh")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getAllContact()
        self.tableView.reloadData()
    }
    
    @objc func refreshAction(sender: Any){
        getAllContact()
        self.tableView.reloadData()
        refreshOutlet.endRefreshing()
    }

    @IBAction func addAction(_ sender: Any) {
        let obj = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactDetailVC") as! DetailViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  allContacts.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellContactID", for: indexPath) as! ContactTableViewCell
        if let temp = allContacts[indexPath.row].value(forKey: "object") as? ContactField {
            cell.contactNameLabel.text = temp.firstName + " " + temp.LastName
            cell.contactAgeLabel.text = String(temp.age)
            
            if temp.photo.count < 10 || cell.contactImageView.image == UIImage(named: "defaultAvatar")  {
                cell.contactImageView.downloaded(from: temp.photo)
                let label = temp.firstName.count > 0
                    ? temp.firstName.prefix(1).uppercased() + temp.LastName.prefix(1).uppercased()
                    : "#"
                cell.contactImageView.setImage(string: label,
                                               color: UIColor.colorHash(name: label),
                                               circular: true,
                                               stroke: false,
                                               textAttributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Medium", size: 32) ?? UIFont.systemFont(ofSize: 24),NSAttributedString.Key.foregroundColor : UIColor.white ])
            } else {
                cell.contactImageView.downloaded(from: temp.photo)
            }
            cell.contactImageView.contentMode = .scaleAspectFill
        }
        // Configure the cell...
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("id:\(allContacts[indexPath.row].value(forKey: "id")!)")
        let obj = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactDetailVC") as! DetailViewController
        obj.currentContact = allContacts[indexPath.row].value(forKey: "object") as? ContactField
        obj.contactID = obj.currentContact?.id
        obj.indexPath = indexPath
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
    private func getAllContact(){
        progressBarDisplayer(allContactIndicatorMsg, removing: false, superView: self.view)
        ContactService.getAllContacts(baseUrlWithKey) {[weak weakSelf = self]
            (error,result,data) -> () in
            DispatchQueue.main.async {
                progressBarDisplayer("", removing: true, superView: self.view)
                if (weakSelf?.refreshOutlet.isRefreshing)!
                {
                    weakSelf?.refreshOutlet.endRefreshing()
                }
                if (error == nil && result == true){
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        allContacts.removeAll()
                        let jsonData = jsonResult["data"] as! NSArray
                        for i in 0..<jsonData.count {
                            print(i)
                            if let dictContact = jsonData.object(at: i) as? [String : Any] {
                                let cont = ContactField(id: dictContact["id"] as! String?, firstName: dictContact["firstName"] as! String?, LastName: dictContact["lastName"] as! String?, age: dictContact["age"] as! Int?, photo: dictContact["photo"] as! String?)
                                let tempDict = ["object":cont]
                                allContacts.append(newElement: tempDict as AnyObject)
                            }
                        }
                        allContacts.getAll()
                        weakSelf?.tableView.reloadData()
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        self.present(createAlertWithOnlyOkay(title: "Error", msg: error.localizedDescription, style: .alert, callBackSelf: self), animated: true) {
                        }
                    }
                }
                else
                {
                    print(error?.localizedDescription ?? errorMessage)
                    allContacts.getAll()
                    weakSelf?.tableView.reloadData()
                    self.present(createAlertWithOnlyOkay(title: "Error", msg: error?.localizedDescription ?? errorMessage, style: .alert, callBackSelf: self), animated: true) {
                    }
                }
            }
            
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
