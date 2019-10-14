//
//  FlickrTest.swift
//  Movie DecadeTests
//
//  Created by Gamal Gamaleldin on 10/14/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import XCTest
@testable import Movie_Decade

class FlickrTest: XCTestCase {

    func testFlickr(){
        FlickrClient.getImagesURLs(movieTitle: "Interstellar") { (imageURLs, _) in
            XCTAssert(imageURLs != nil , "ImageURLs returned a nil which is not expected behaviour.")
            XCTAssert(imageURLs!.count > 0 , "ImageURLs returned an empty array which is not expected behaviour.")
        }
    }


}
