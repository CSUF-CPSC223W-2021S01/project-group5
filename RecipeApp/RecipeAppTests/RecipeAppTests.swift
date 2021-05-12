//
//  RecipeAppTests.swift
//  RecipeAppTests
//
//  Created by Jes Ray Manguiat on 3/10/21.
//

@testable import RecipeApp
import XCTest

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
    
    func testRecipeContainerInit() {
        let myRecipeContainer = RecipeContainer("RecipeName", "Description", ["Ingredient": "Info"], [Tuple("", nil)], "TotalTime")
        XCTAssertNotNil(myRecipeContainer)
    } // tests for the initialization of a RecipeContainer object
    
    func testSearchRecipe() {
        let myClassObject = C_Categories()
        let categoryName = "categoryName"
        myClassObject.AddCategory(categoryName)
        let myRecipeContainer = RecipeContainer("RecipeName", "Description", ["Ingredient": "Info"], [Tuple("", nil)], "TotalTime")
        myClassObject.AddRecToCat(categoryName, newRecipe: myRecipeContainer) == (true, 1)
        XCTAssertNotNil(searchRecipe(attribute: searchAtt.name, searchStr: myRecipeContainer.RecipeName))
    }
    
    func testCategories() {
        let myCategories = C_Categories()
        XCTAssertNotNil(myCategories.Categories)
    } // tests if there is existing content within the Categories variable

    func testAddCategory() {
        let myClassObject = C_Categories()
        let categoryName = "categoryName"
        XCTAssert(myClassObject.AddCategory(categoryName) == true)
    } // tests if the AddCategory function adds the category
    
    func testAddCategoryExists() {
        let myClassObject = C_Categories()
        let categoryName = "categoryName"
        myClassObject.AddCategory(categoryName)
        XCTAssert(myClassObject.AddCategory(categoryName) == false)
    } // tests for the case when a category already exists using AddCategory
    
    func testRemoveCategoryExists() {
        let myClassObject = C_Categories()
        let categoryName = "categoryName"
        myClassObject.AddCategory(categoryName)
        XCTAssert(myClassObject.RemoveCategory(categoryName) == true)
    } // tests for the case when removing an exisisting category
    
    func testRemoveCategory() {
        let myClassObject = C_Categories()
        let categoryName = "categoryName"
        myClassObject.AddCategory(categoryName)
        myClassObject.RemoveCategory(categoryName)
        XCTAssert(myClassObject.RemoveCategory(categoryName) == false)
    } // tests for the functionality of RemoveCategory and the case when a category doesn't exist
    
    func testAddRecToCatFails() {
        let myClassObject = C_Categories()
        let categoryName = "categoryName"
        let myRecipeContainer = RecipeContainer("RecipeName", "Description", ["Ingredient": "Info"], [Tuple("", nil)], "TotalTime")
        XCTAssert(myClassObject.AddRecToCat(categoryName, newRecipe: myRecipeContainer) == (false, -1))
    } // tests for the case in which category doesn't exist
    
    func testAddRecToCatSuccess() {
        let myClassObject = C_Categories()
        let categoryName = "categoryName"
        myClassObject.AddCategory(categoryName)
        let myRecipeContainer = RecipeContainer("RecipeName", "Description", ["Ingredient": "Info"], [Tuple("", nil)], "TotalTime")
        XCTAssert(myClassObject.AddRecToCat(categoryName, newRecipe: myRecipeContainer) == (true, 1))
    } // tests for the case in which category exists
    
    func testAddRecToCatExists() {
        let myClassObject = C_Categories()
        let categoryName = "categoryName"
        myClassObject.AddCategory(categoryName)
        let myRecipeContainer = RecipeContainer("RecipeName", "Description", ["Ingredient": "Info"], [Tuple("", nil)], "TotalTime")
        myClassObject.AddRecToCat(categoryName, newRecipe: myRecipeContainer)
        XCTAssert(myClassObject.AddRecToCat(categoryName, newRecipe: myRecipeContainer) == (false, 0))
    } // tests for the case in which an instance of a recipe already exists
    
    func testRemoveRecFromCatFails() {
        let myClassObject = C_Categories()
        let categoryName = "categoryName"
        XCTAssert(myClassObject.RemoveRecFromCat(categoryName, RecIndex: 0) == (false, -1))
    } // tests for the case in which category doesn't exist
    
    func testRemoveRecFromCatOutOfBounds() {
        let myClassObject = C_Categories()
        let categoryName = "categoryName"
        myClassObject.AddCategory(categoryName)
        let myRecipeContainer = RecipeContainer("RecipeName", "Description", ["Ingredient": "Info"], [Tuple("", nil)], "TotalTime")
        myClassObject.AddRecToCat(categoryName, newRecipe: myRecipeContainer)
        XCTAssert(myClassObject.RemoveRecFromCat(categoryName, RecIndex: -1) == (false, 0))
    } // tests the case in which RecIndex is out of bounds
    
    func testRemoveRecFromCat() {
        let myClassObject = C_Categories()
        let categoryName = "categoryName"
        myClassObject.AddCategory(categoryName)
        let myRecipeContainer = RecipeContainer("RecipeName", "Description", ["Ingredient": "Info"], [Tuple("", nil)], "TotalTime")
        myClassObject.AddRecToCat(categoryName, newRecipe: myRecipeContainer)
        XCTAssert(myClassObject.RemoveRecFromCat(categoryName, RecIndex: 0) == (true, 0))
    } // tests for the success of the RemoveRecFromCat function
}
