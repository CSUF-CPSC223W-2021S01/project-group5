//
//  CategoriesViewController.swift
//  RecipeApp
//
//  Created by Kai Eusebio on 5/9/21.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    //var CatKeys: [String] = Array(Categories.Categories.keys)
    var CatKeys: [String] = ["Healthy","Burgers","Japanese","Italian","Spicy"]
    
    @IBOutlet var CatButton: UIButton!
    @IBOutlet var CatTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CatTableView.delegate = self
        CatTableView.dataSource = self
    }
}


extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CatKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CatTableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = CatKeys[indexPath.row]	
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        print("Selected \(CatKeys[indexPath.row])")
    }
    
    
}
