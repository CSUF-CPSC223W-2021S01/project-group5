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
// array that stores every recipe. The "All" Category.
// Issue: Sorting alphabetical may be difficult with array, consider using
//        a dictionary instead.
var MasterList: [RecipeContainer] = []

// Category dictionary. key = "name", value = array of recipes in category
// Issue: sorting the array may be diffult so consider changing to
//        dictionary of [String: Dictionary(String, Recipe Container)]
var Categories: [String: [RecipeContainer]] = ["All": MasterList]

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
    // Issue: Do I need to worry about this array if the key is removed?
    //        How would I access this array?
    Categories[CName] = [RecipeContainer]()
    return true
}

// RemoveCategory ==============================================================
// Description: Removes the given category from the Categories Dictionary.
// Input:       CName: String - name of the category to remove
// Output:      Bool - returns false if category not found, true on removal
// =============================================================================
func RemoveCategory(_ CName: String) -> Bool {
    // checks if category exists, returns false if not found
    guard Categories.removeValue(forKey: CName) != nil else {
        return false
    }

    // passed guard so it was removed.
    return true
}

// AddRecToCat =================================================================
// Description: Appends recipe to the given category
// Input: CName: String - Category to add to
// Output: (Bool, Int) - on success returns true and new count
// =============================================================================
func AddRecToCat (_ CName:String, newRecipe: RecipeContainer) -> (Bool, Int) {
    // checks if category exists
    guard Categories[CName] != nil else{
        return (false, -1)
    }
    // loop to check if recipe exists
    /*
    for _______ {
        //if found return (false, index)
     
     }
    */
    
    // Appends recipe to the array for the given key CName
    Categories[CName]!.append(newRecipe)
    return (true, (Categories[CName]!.count))
}

// RemoveRecFromCat ============================================================
// Description: Removes recipe from the category
// Input: ?
// Output: (Bool, Int) - on success returns true and new count
// =============================================================================
func RemoveRecFromCat (_ CName:String , remRecipe: RecipeContainer) -> (Bool, Int) {
    // checks if category exists
    guard Categories[CName] != nil else{
        return (false, -1)
    }
    
    // loop thru array and remove indexes where remRecipe exists
    /*
    for _______ {
        //if found remove it from the array then
        return (true, Categories[CName]!.count)
     }
    */
    
    // wasn't found
    return (false, 0)
}
