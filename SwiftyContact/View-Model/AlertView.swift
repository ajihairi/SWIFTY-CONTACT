//
//  AlertView.swift
//  SwiftyContact
//
//  Created by ajihairi on 18/05/19.
//  Copyright © 2019 hamzhya. All rights reserved.
//

import Foundation
import UIKit

func createAlertWithOnlyOkay(title:String?, msg:String, style:UIAlertController.Style, callBackSelf:UIViewController) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: msg, preferredStyle: style)
    
    let cancelAction = UIAlertAction(title: "Okay", style: .cancel) { action in
        callBackSelf.dismiss(animated: true, completion: {
            
        })
    }
    alertController.addAction(cancelAction)
    return alertController
}


