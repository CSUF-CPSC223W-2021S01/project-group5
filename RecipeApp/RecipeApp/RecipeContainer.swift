//
//  RecipeContainer.swift
//  RecipeApp
//
//  Created by Mathias  on 3/10/21.
//
//  Description:
//      This file manages the recipes and where they are stored

import Foundation
import SwiftUI

class RecipeContainer { //Creating a class for storing recipes, need to read up on docs about storage
    var RecipeName: String
    var Description: String? //not every recipe needs a description
    var Image: String? {
        return nil
    }
    var Ingredients: [String: String]
    var Steps = Array<Any>(arrayLiteral: String(), Int?.self) //creates an empty array
    //and accepts an empty string and an optional int, checks the time in steps I think, **I've no idea this was just spagetti code, might have to fix this later if not working**
    var TotalTime: String {
        return("Time: \(Steps.count)")
    }
    
    init(_ RecipeName: String, _ Description: String, _ Ingredients: [String: String]) {
        self.RecipeName = RecipeName
        self.Description = Description
        self.Ingredients = Ingredients
    } //init for names and description
    
}
