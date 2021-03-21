//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Mark Gonzalez on 3/21/21.
//

import UIKit

class RecipeViewController: UIViewController {

    var rImage: UIImage?
    @IBOutlet private var recipeImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if rImage != nil {
            recipeImage.image = rImage
        } else {
            //have label with recipe name and colored background or something
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
