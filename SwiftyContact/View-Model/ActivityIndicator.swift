//
//  ActivityIndicator.swift
//  SwiftyContact
//
//  Created by ajihairi on 18/05/19.
//  Copyright © 2019 hamzhya. All rights reserved.
//

import Foundation
import UIKit

func progressBarDisplayer(_ msg: String, removing: Bool, superView:UIView) {
    if !removing {
        let messageFrame = UIView()
        messageFrame.layer.cornerRadius = 5
        messageFrame.tag = 51
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        messageFrame.frame = CGRect(x: (superView.frame.width/2) - 80, y: (superView.frame.height/2) - 50, width: 160, height: 50)
        
        let lblProgressMsg = UILabel(frame: CGRect(x: 50, y: 10, width: 160, height: 30))
        lblProgressMsg.text = msg
        lblProgressMsg.textColor = UIColor.white
        lblProgressMsg.numberOfLines = 1
        lblProgressMsg.adjustsFontSizeToFitWidth = true
        lblProgressMsg.minimumScaleFactor = 0.5
        
        messageFrame.addSubview(lblProgressMsg)
        
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        superView.addSubview(messageFrame)
        superView.isUserInteractionEnabled = false
    } else {
        for tmpview in superView.subviews {
            if tmpview.tag == 51 {
                tmpview.removeFromSuperview()
                superView.isUserInteractionEnabled = true
                break
            }
        }
    }
}


