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
var MasterList:[RecipeContainer] = []

// Category dictionary. key = "name", value = array of recipes in category
// Issue: sorting the array may be diffult so consider changing to
//        dictionary of [String: Dictionary(String, Recipe Container)]
var Categories: [String:[RecipeContainer]] = ["All":MasterList]

// AddCategory =================================================================
// Description: Creates a new category by adding it to the Categories Dict.
// Input:       String - name of the category to add
// Output:      Bool - returns false if it already exists, true on success
// =============================================================================
func AddCategory(_ CName:String) -> Bool {
    // checks to see if it already exists
    guard Categories[CName] == nil else{
        return false
    }
    // Creates new Category and array to go with it.
    // Issue: Do I need to worry about this array if the key is removed?
    //        How would I access this array?
    Categories[CName] = Array<RecipeContainer>()
    return true
}

// RemoveCategory ==============================================================
// Description: Removes the given category from the Categories Dictionary.
// Input:       String - name of the category to remove
// Output:      Bool - returns false if category not found, true on removal
// =============================================================================
func RemoveCategory(_ CName:String) -> Bool {
    // checks if category exists, returns false if not found
    guard Categories.removeValue(forKey: CName) != nil else {
        return false
    }
    
    // passed guard so it was removed.
    return true
}

// AddRecToCat =================================================================
// Description: Appends recipe to the given category
// Input: ?
// Output: ?
// =============================================================================

// RemoveRecFromCat ============================================================
// Description: Removes recipe from the category
// Input: ?
// Output: ?
// =============================================================================
