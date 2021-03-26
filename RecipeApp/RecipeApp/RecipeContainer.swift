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

class RecipeContainer {
    //Creating a class for storing recipes, need to read up on docs about storage
    var RecipeName: String
    var Description: String?
    //An optional because not every recipe needs a description
    var Image: String? {
        return nil
    }
    var Ingredients: [String: String]
    var Steps: [(instruction: String, duration: Int?)] = [("", nil)]
    //Accepts an empty string and an optional int, checks the time in steps, **might have to fix this later if not working**
    var TotalTime: String {
        return("Time: \(Steps.count)")
        //Counts the time in the string array from Steps and returns it
    }
    
    init(_ RecipeName: String, _ Description: String, _ Ingredients: [String: String], _ Steps: [(String, Int?)], _ TotalTime: String) {
        self.RecipeName = RecipeName
        self.Description = Description
        self.Ingredients = Ingredients
        self.Steps = Steps
    }
    //init for names and description
    
}

