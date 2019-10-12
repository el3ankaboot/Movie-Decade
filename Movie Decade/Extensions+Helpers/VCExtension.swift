//
//  VCExtension.swift
//  Movie Decade
//
//  Created by Gamal Gamaleldin on 10/11/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    //MARK:- Alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Activity indicator
    func startAnimating(_ activity: UIActivityIndicatorView){
        activity.isHidden = false
        activity.startAnimating()
    }
    
    func stopAnimating(_ activity: UIActivityIndicatorView){
        activity.isHidden = true
        activity.stopAnimating()
    }
}
