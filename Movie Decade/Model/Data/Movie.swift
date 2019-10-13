//
//  Movie.swift
//  Movie Decade
//
//  Created by Gamal Gamaleldin on 10/11/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
struct Response : Codable {
    struct Movie: Codable {
        var title: String
        var year: Int
        var cast: [String]?
        var genres : [String]?
        var rating : Int
    }
    var movies : [Movie]
}
