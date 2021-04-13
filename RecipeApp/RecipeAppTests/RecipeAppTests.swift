//
//  RecipeAppTests.swift
//  RecipeAppTests
//
//  Created by Mark Gonzalez on 3/10/21.
//

import XCTest
@testable import RecipeApp

class RecipeAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testMasterListInitializer() {
        let myMasterList = MasterList
        XCTAssertEqual(myMasterList.count, 0)
    } // tests initialization of the MasterList
    
    func testCategories() {
        let myCategories = C_Categories()
        XCTAssertNotNil(myCategories.Categories)
    } // tests if there is existing content within the Categories variable

    func testAddCategory() {
        let myClassObject = C_Categories()
        let myCategory = "myCategory"
        XCTAssert(myClassObject.AddCategory(myCategory) == true)
    } // tests if the AddCategory function adds the category
    
    func testExistingCategory() {
        let myClassObject = C_Categories()
        let myCategory = "myCategory"
        myClassObject.AddCategory(myCategory)
        XCTAssert(myClassObject.AddCategory(myCategory) == false)
    } // tests for the case when a category already exists using AddCategory
}
