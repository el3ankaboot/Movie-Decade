//
//  ImagesCell.swift
//  Movie Decade
//
//  Created by Gamal Gamaleldin on 10/12/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import UIKit

class ImagesCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var shimmer: FBShimmeringView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shimmer = FBShimmeringView(frame: self.frame)
        shimmer.layer.cornerRadius = 5.0
        self.contentView.addSubview(shimmer)
        shimmer.contentView = imageView
        shimmer.isShimmering = true
    }
}
