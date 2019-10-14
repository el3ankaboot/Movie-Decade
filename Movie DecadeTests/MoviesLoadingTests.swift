//
//  MoviesLoadingTests.swift
//  Movie DecadeTests
//
//  Created by Gamal Gamaleldin on 10/13/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//


import XCTest
@testable import Movie_Decade

class MovieLoadingTests: XCTestCase {
    
    var data : MoviesData!
    
    override func setUp() {
        super.setUp()
        data = MoviesData(resourceName: "moviesTest")
    }
    
    func testLoadCount(){
        XCTAssertEqual(data.moviesArray.count , 25)
    }
    
    func testLoadedFirstMovieCorrectly(){
        let firstMovie = data.moviesArray[0]
        XCTAssertEqual(firstMovie.title , "12 years a slave")
        XCTAssertEqual(firstMovie.year , 2013)
        XCTAssertEqual(firstMovie.rating , 1)
        XCTAssertEqual(firstMovie.cast?.count , 4)
        XCTAssertEqual(firstMovie.genres?.count , 3 )
    }
    
    func testLoadedSecondMovieCorrectly(){
        let secondMovie = data.moviesArray[1]
        XCTAssertEqual(secondMovie.title , "Movie 1")
        XCTAssertEqual(secondMovie.year , 2013)
        XCTAssertEqual(secondMovie.rating , 5)
        XCTAssertEqual(secondMovie.cast?.count , 2)
        XCTAssertEqual(secondMovie.genres?.count , 2)
    }
    
    func testLoadedThirdMovieCorrectly(){
        let thirdMovie = data.moviesArray[2]
        XCTAssertEqual(thirdMovie.title , "13 years a slave")
        XCTAssertEqual(thirdMovie.year , 2014)
        XCTAssertEqual(thirdMovie.rating , 4)
        XCTAssertEqual(thirdMovie.cast?.count , 4 )
        XCTAssertEqual(thirdMovie.genres?.count , 3)
    }
    
    func testLoadedFourthMovieCorrectly(){
        let fourthMovie = data.moviesArray[3]
        XCTAssertEqual(fourthMovie.title , "4 rated movie")
        XCTAssertEqual(fourthMovie.year , 2013)
        XCTAssertEqual(fourthMovie.rating , 4)
        XCTAssertEqual(fourthMovie.cast?.count , 1)
        XCTAssertEqual(fourthMovie.genres?.count , 1)
    }
    
    func testLoadedFifthMovieCorrectly(){
        let fifthMovie = data.moviesArray[4]
        XCTAssertEqual(fifthMovie.title, "2012")
        XCTAssertEqual(fifthMovie.year , 2012)
        XCTAssertEqual(fifthMovie.rating , 4)
        XCTAssertEqual(fifthMovie.cast?.count , 1)
        XCTAssertEqual(fifthMovie.genres?.count , 1)
    }
    
    func testLoadedSixthMovieCorrectly(){
        let sixthMovie = data.moviesArray[5]
        XCTAssertEqual(sixthMovie.title, "movie 2011")
        XCTAssertEqual(sixthMovie.year , 2011)
        XCTAssertEqual(sixthMovie.rating , 4)
        XCTAssertEqual(sixthMovie.cast , nil)
        XCTAssertEqual(sixthMovie.genres?.count , 1)
    }
    
    func testLoadedSeventhMovieCorrectly(){
        let seventhMovie = data.moviesArray[6]
        XCTAssertEqual(seventhMovie.title, "movie 2013")
        XCTAssertEqual(seventhMovie.year , 2013)
        XCTAssertEqual(seventhMovie.rating , 4)
        XCTAssertEqual(seventhMovie.cast?.count , 1)
        XCTAssertEqual(seventhMovie.genres , nil)
    }
    
    func testLoadedEighthMovieCorrectly(){
        let eighthMovie = data.moviesArray[7]
        XCTAssertEqual(eighthMovie.title, "movie 2013 rate 3")
        XCTAssertEqual(eighthMovie.year , 2013)
        XCTAssertEqual(eighthMovie.rating , 3)
        XCTAssertEqual(eighthMovie.cast?.count , 2)
        XCTAssertEqual(eighthMovie.genres?.count , 1)
    }
    
    func testLoadedNinthMovieCorrectly(){
        let ninthMovie = data.moviesArray[8]
        XCTAssertEqual(ninthMovie.title, "movie 2012 rate 3")
        XCTAssertEqual(ninthMovie.year , 2012)
        XCTAssertEqual(ninthMovie.rating , 3)
        XCTAssertEqual(ninthMovie.cast?.count , 2)
        XCTAssertEqual(ninthMovie.genres?.count , 1)
    }
    
    func testLoadedTenthMovieCorrectly(){
        let tenthMovie = data.moviesArray[9]
        XCTAssertEqual(tenthMovie.title, "Best 2012")
        XCTAssertEqual(tenthMovie.year , 2012)
        XCTAssertEqual(tenthMovie.rating , 5)
        XCTAssertEqual(tenthMovie.cast?.count , 2)
        XCTAssertEqual(tenthMovie.genres?.count , 1)
    }
    
    func testLoadedElevnthMovieCorrectly(){
        let eleventhMovie = data.moviesArray[10]
        XCTAssertEqual(eleventhMovie.title, "Interstellar")
        XCTAssertEqual(eleventhMovie.year , 2013)
        XCTAssertEqual(eleventhMovie.rating , 5)
        XCTAssertEqual(eleventhMovie.cast?.count , 2)
        XCTAssertEqual(eleventhMovie.genres?.count , 1)
    }
    
    func testLoadedTwelfthMovieCorrectly(){
        let twelfthMovie = data.moviesArray[11]
        XCTAssertEqual(twelfthMovie.title, "The Interstellar")
        XCTAssertEqual(twelfthMovie.year , 2013)
        XCTAssertEqual(twelfthMovie.rating , 5)
        XCTAssertEqual(twelfthMovie.cast?.count , 2)
        XCTAssertEqual(twelfthMovie.genres?.count , 1)
    }
    
    func test13to25LoadedCorrectly() {
        moviesOf2010Assertions(index: 12, rate: 1)
        moviesOf2010Assertions(index: 13, rate: 5)
        moviesOf2010Assertions(index: 14, rate: 2)
        moviesOf2010Assertions(index: 15, rate: 3)
        moviesOf2010Assertions(index: 16, rate: 4)
        moviesOf2010Assertions(index: 17, rate: 5)
        moviesOf2010Assertions(index: 18, rate: 1)
        moviesOf2010Assertions(index: 19, rate: 5)
        moviesOf2010Assertions(index: 20, rate: 1)
        moviesOf2010Assertions(index: 21, rate: 4)
        moviesOf2010Assertions(index: 22, rate: 5)
        moviesOf2010Assertions(index: 23, rate: 4)
        moviesOf2010Assertions(index: 24, rate: 5)
        
        
    }
    
    func moviesOf2010Assertions(index:Int, rate:Int){
        let movie = data.moviesArray[index]
        XCTAssertEqual(movie.title, "2010rate\(rate)")
        XCTAssertEqual(movie.year , 2010)
        XCTAssertEqual(movie.rating , rate)
        XCTAssertEqual(movie.cast?.count , 1)
        XCTAssertEqual(movie.genres?.count , 1)
    }
    
    
}

