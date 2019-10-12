//
//  ImagesTopCollectionReusableView.swift
//  Movie Decade
//
//  Created by Gamal Gamaleldin on 10/12/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import UIKit
import Cosmos

class ImagesTopCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: CosmosView!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var genresView: UIView!
    @IBOutlet weak var castView: UIView!
    @IBOutlet weak var genresViewHeight: NSLayoutConstraint!
    @IBOutlet weak var castViewHeight: NSLayoutConstraint!
    
    
}
