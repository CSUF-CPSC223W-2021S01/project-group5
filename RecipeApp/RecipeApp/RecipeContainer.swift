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

class RecipeContainer: Codable{
    //Creating a class for storing recipes, need to read up on docs about storage
    var RecipeName: String
    var Description: String?
    //An optional because not every recipe needs a description
    var Image: String? {
        return nil
    }
    var Ingredients: [String: String]
    var Steps: [Tuple] = [Tuple(instruction: "", duration: nil)]
    //Accepts an empty string and an optional int, checks the time in steps, **might have to fix this later if not working**
    var TotalTime: String {
        return("Time: \(Steps.count)")
        //Counts the time in the string array from Steps and returns it
    }
    
    init(_ RecipeName: String, _ Description: String, _ Ingredients: [String: String], _ Steps: [Tuple], _ TotalTime: String) {
        self.RecipeName = RecipeName
        self.Description = Description
        self.Ingredients = Ingredients
        self.Steps = Steps
    }
}

//Below: Creating a search function that accepts an enum and string to return an array of recipes
func searchRecipe(attribute: searchAtt, searchStr: String) -> Array<RecipeContainer>{
   //searches through masterlist to match patterns and stores recipes
    /*let RecipeArray = MasterList
    for recipe in MasterList{
        let _recipe = MasterList.RecipeContainer
    }*/
    var SearchArray: [RecipeContainer] = []
    switch attribute {
    case searchAtt.name:
        for recipe in MasterList {
            if (recipe.RecipeName.range(of: searchStr) != nil){
                SearchArray.append(recipe)
            }
        }
        return SearchArray
    case searchAtt.ingredient:
        for recipe in MasterList {
            if (recipe.Ingredients.keys.contains(searchStr)) {
                SearchArray.append(recipe)
            }
        }
        return SearchArray
    case searchAtt.time:
        for recipe in MasterList {
            if ((recipe.TotalTime.range(of: searchStr)) != nil) {
                SearchArray.append(recipe)
            }
        }
        return SearchArray
    }
}
