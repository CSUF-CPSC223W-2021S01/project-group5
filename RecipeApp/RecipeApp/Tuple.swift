//
//  Tuple.swift
//  RecipeApp
//
//  Created by Kai Eusebio on 4/22/21.
//

import Foundation
// When making RecipeContainer follow the Codable protocol I found out that
// tupples aren't encodeable. As a work around I made a Codable Tupple class
// instead. The following is old vs new declartion for the var Steps in RC:
// OLD: var Steps: [(instruction: String, duration: Int?)] = [("", nil)]
// NEW: var Steps: [Tuple] = [Tuple("", nil)]
// OR:  var Steps: [Tuple] = [Tuple(instruction: "", duration: nil)]
class Tuple: Codable{
    var instruction: String
    var duration: Int?
    init(_ instruction: String, _ duration: Int?){
        self.instruction = instruction
        self.duration = duration
    }
    init( instruction: String,  duration: Int?){
        self.instruction = instruction
        self.duration = duration
    }
}

