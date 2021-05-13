//
//  SettingsViewController.swift
//  RecipeApp
//
//  Created by Kai Eusebio on 5/11/21.
//

import UIKit

class SettingsViewController: UIViewController {
    var lightOn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        lightOn = !lightOn
        
        if lightOn {
            view.backgroundColor = .white
        } else {
            view.backgroundColor = .black
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
