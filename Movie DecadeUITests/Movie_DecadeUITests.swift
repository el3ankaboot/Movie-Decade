//
//  Movie_DecadeUITests.swift
//  Movie DecadeUITests
//
//  Created by Gamal Gamaleldin on 10/14/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import XCTest

class Movie_DecadeUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testSearch(){
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.searchFields["Search for movie by year"].tap()
        app/*@START_MENU_TOKEN@*/.keys["2"]/*[[".keyboards.keys[\"2\"]",".keys[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["0"]/*[[".keyboards.keys[\"0\"]",".keys[\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let key1 = app/*@START_MENU_TOKEN@*/.keys["1"]/*[[".keyboards.keys[\"1\"]",".keys[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key1.tap()
        key1.tap()
        app.toolbars["Toolbar"].buttons["Search"].tap()
        XCTAssertTrue(tablesQuery.element.exists, "No table shown on search, which is an unexpected behaviour")
        XCTAssertTrue(tablesQuery.element.tableRows.count <= 5, "Expected number of rows is less than the actual.")
        
    }
    
    func testSearchInvalid(){
        
        let app = XCUIApplication()
        app.tables.searchFields["Search for movie by year"].tap()
        
        let key2 = app/*@START_MENU_TOKEN@*/.keys["2"]/*[[".keyboards.keys[\"2\"]",".keys[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let key0 = app/*@START_MENU_TOKEN@*/.keys["0"]/*[[".keyboards.keys[\"0\"]",".keys[\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key2.tap()
        key0.tap()
        key0.tap()
        key2.tap()
        app.toolbars["Toolbar"].buttons["Search"].tap()
        XCTAssertTrue(app.alerts["Invalid Year"].exists, "No Alert appeared on wrong search query.")
        
    }
    
    func testShowDetail(){
        
        let app = XCUIApplication()
        app.tables.cells.element(boundBy: 0).tap()
        XCTAssertFalse(app.collectionViews.element.exists , "Movie Details Should only be shown for those in search results.")
        
    }
    
    func testShowDetailFromSearch(){
        testSearch()
        let app = XCUIApplication()
        app.tables.cells.element(boundBy: 0).tap()
        XCTAssertTrue(app.collectionViews.element.exists , "Didn't show movie details.")
    }
        
}
