//
//  Save.swift
//  RecipeApp
//
//  Created by Kai Eusebio on 4/22/21.
//

import Foundation

let myDocDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let ML_URL = myDocDir.appendingPathComponent("MasterList").appendingPathExtension("plist")
let CAT_URL = myDocDir.appendingPathComponent("Category").appendingPathExtension("plist")

// SaveData ====================================================================
// Description: Encodes MasterList array then saves to file named myURL
// Input:       N/A
// Output:      N/A
// =============================================================================
func SaveData() {
    // Save the MasterList array into a file called MasterList.plist
    let plistEncoder = PropertyListEncoder()
    if let encodedMasterList = try? plistEncoder.encode(MasterList),
       let encodedCategories = try? plistEncoder.encode(Categories)
    {
        try? encodedMasterList.write(to: ML_URL)
        try? encodedCategories.write(to: CAT_URL)
    }
} // end of SaveData()

// LoadData ====================================================================
// Description: Decodes data from URL then saves to coresponding objects
// Input:       N/A
// Output:      true if decoded data was saved to MasterList
//              false on failure
// =============================================================================
func LoadData() -> Bool {
    let plistDecoder = PropertyListDecoder()
    if let retMLData = try? Data(contentsOf: ML_URL),
       let decodedML = try? plistDecoder.decode([RecipeContainer].self, from: retMLData),
       let retCATData = try? Data(contentsOf: CAT_URL),
       let decodedCAT = try? plistDecoder.decode(C_Categories.self, from: retCATData)
    {
        MasterList = decodedML
        Categories = decodedCAT
        return true
    }

    return false
} // end of LoadData()
