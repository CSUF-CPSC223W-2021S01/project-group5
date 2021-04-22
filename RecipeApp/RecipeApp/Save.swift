//
//  Save.swift
//  RecipeApp
//
//  Created by Kai Eusebio on 4/22/21.
//

import Foundation

let myDocDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let ML_URL = myDocDir.appendingPathComponent("MasterList").appendingPathExtension("plist")
let CAT_URL = myDocDir.appendingPathComponent("MasterList").appendingPathExtension("plist")
// SaveData ====================================================================
// Description: Encodes MasterList array then saves to file named myURL
// Input:       N/A
// Output:      N/A
// =============================================================================
func SaveData() {
    //Save the MasterList array into a file called MasterList.plist
    let plistEncoder = PropertyListEncoder()
    if let encodedMasterList = try? plistEncoder.encode(MasterList) {
        try? encodedMasterList.write(to: ML_URL)
    }
    
}// end of saveData()


func LoadData() {
    
    
}
