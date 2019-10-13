//
//  PerformanceTests.swift
//  Movie DecadeTests
//
//  Created by Gamal Gamaleldin on 10/13/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import XCTest
@testable import Movie_Decade

class PerformanceTests: XCTestCase {
    typealias Movie = Response.Movie
    
    func testPerformance () {
        self.measure {
            //Testing with the real data not the test ones.
            _ = MoviesData(resourceName: "movies")
        }
    }
    
    func testSearchPerformance() {
        let data = MoviesData(resourceName: "movies")
        self.measure {
            data.handleSearch(2012)
        }
    }
    
    func testBinarySortInsertPerformance(){
        let data = MoviesData(resourceName: "movies")
        var movie = Movie(title: "Test Insert", year: 2010, cast: ["First Actor","Second Actor"], genres: ["Test"], rating: 5)
        self.measure {
            data.insertMovieSorted(movie: movie, array: data.moviesArray)
        }
    }

}
