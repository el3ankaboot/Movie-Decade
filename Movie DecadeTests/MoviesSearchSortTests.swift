//
//  MoviesSearchSortTests.swift
//  Movie DecadeTests
//
//  Created by Gamal Gamaleldin on 10/13/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import XCTest
@testable import Movie_Decade

class MoviesSearchSortTests: XCTestCase {

    var data : MoviesData!
    
    override func setUp() {
        super.setUp()
        data = MoviesData(resourceName: "moviesTest")
    }
    
    func test2014SearchCount(){
        data.handleSearch(2014)
        XCTAssertEqual(data.moviesSearched.count , 1)
    }
    
    func test2012SearchCount(){
        data.handleSearch(2012)
        XCTAssertEqual(data.moviesSearched.count , 3)
    }
    
    func testNotAdding(){
        //Testing that doing 2 searches doesn't add to each other
        data.handleSearch(2014)
        data.handleSearch(2012)
        XCTAssertEqual(data.moviesSearched.count, 3)
    }
    
    func testMaximum5() {
        //Testing that if there are more than 5 movies , the returned is only 5
        data.handleSearch(2013)
        XCTAssertEqual(data.moviesSearched.count, 5)
    }
    
    func testTop5() {
        //Testing that the returned are the top 5
        data.handleSearch(2013)
        var countOf5 = 0
        var countOf4 = 0
        for movie in data.moviesSearched {
            if(movie.rating == 5){countOf5+=1}
            if(movie.rating == 4){countOf4+=1}
            
        }
        XCTAssertEqual(countOf5, 3)
        XCTAssertEqual(countOf4, 2)
        
    }
    
    func testTop5_2() {
        //another test that the returned are the top 5
        data.handleSearch(2010)
        var countOf5 = 0
        for movie in data.moviesSearched {
            if(movie.rating == 5){countOf5+=1}
            
        }
        XCTAssertEqual(countOf5, 5)
    }
    


}
