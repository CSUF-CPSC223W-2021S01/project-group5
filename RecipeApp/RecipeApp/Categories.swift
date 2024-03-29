//
//  File: Categories.swift
//  Program: RecipeApp
//
//  Created by Kai Eusebio on 3/18/21.
//
//  Description:
//      This file manages the Categories Section of the Cook Book App.
//

import Foundation

class C_Categories: Codable {
    // Category Dictionary. key is name of category, value is array of recipes in category
    var Categories: [String: [RecipeContainer]] = ["All": MasterList]
}

// Member Functions
extension C_Categories {
    // AddCategory =================================================================
    // Description: Creates a new category by adding it to the Categories Dict.
    // Input:       String - name of the category to add
    // Output:      Bool - returns false if it already exists, true on success
    // =============================================================================
    func AddCategory(_ CName: String) -> Bool {
        // checks to see if it already exists
        guard Categories[CName] == nil else {
            return false
        }
        // Creates new Category and array to go with it.
        Categories[CName] = [RecipeContainer]()
        return true
    } // end of AddCategory()

    // RemoveCategory ==============================================================
    // Description: Removes the given category from the Categories Dictionary.
    // Input:       CName: String - name of the category to remove
    // Output:      Bool - returns false if category not found, true on removal
    // =============================================================================
    func RemoveCategory(_ CName: String) -> Bool {
        // checks if category exists and removes, returns false if not found
        guard Categories.removeValue(forKey: CName) != nil else {
            return false
        }

        // passed guard so it was removed.
        return true
    } // end of RemoveCategory()

    // AddRecToCat =================================================================
    // Description: Appends recipe to the given category
    // Input: CName: String - Category to add to
    // Output: (Bool, Int) - on success returns true and new count
    // =============================================================================
    func AddRecToCat(_ CName: String, newRecipe: RecipeContainer) -> (Bool, Int) {
        // checks if category exists
        guard Categories[CName] != nil else {
            return (false, -1)
        }

        // loop to check if an instance of the recipe exists in array already
        for rec in Categories[CName]! {
            if rec === newRecipe {
                return (false, 0)
            }
        }

        // Appends recipe to the array in the category and returns true w/ count
        Categories[CName]!.append(newRecipe)
        return (true, Categories[CName]!.count)
    } // end of AddRecToCat ()

    // RemoveRecFromCat ============================================================
    // Description: Removes recipe from the category
    // Input:   CName: String - name of category to remove from
    //          RecIndex: Int - Index to remove recipe from array in Category Dict.
    // Output: (Bool, Int) - on success returns true and new count of recipes
    //              (false, -1) - category not found
    //              (false, 0)  - index out of bounds
    // =============================================================================
    func RemoveRecFromCat(_ CName: String, RecIndex: Int) -> (Bool, Int) {
        // checks if category exists
        guard Categories[CName] != nil else {
            return (false, -1)
        }
        // checks index is in range
        guard RecIndex >= 0, RecIndex < Categories[CName]!.count else {
            return (false, 0)
        }

        Categories[CName]?.remove(at: RecIndex)
        return (true, Categories[CName]!.count)
    } // end of RemoveRecFromCat()
} // end of C_Categories
