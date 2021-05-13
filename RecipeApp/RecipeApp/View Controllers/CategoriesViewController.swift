//
//  CategoriesViewController.swift
//  RecipeApp
//
//  Created by Kai Eusebio on 5/9/21.
//
//  used this video for reference when making CategoriesViewController and RecipeListViewController
//  https://youtu.be/mTmJnPabUWg

import UIKit

class CategoriesViewController: UIViewController {
    var CatKeys: [String] = Array(Categories.Categories.keys)
    //var CatKeys: [String] = ["Healthy", "Burgers", "Japanese", "Italian", "Spicy"]
    
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
        tableView.deselectRow(at: indexPath, animated: true)
        //print("Selected \(CatKeys[indexPath.row])")
        
        let CategoryName = CatKeys[indexPath.row]
        var Rname: [String] = []
        
        for i in 0...(Categories.Categories[CatKeys[indexPath.row]]!.count-1) {
            Rname.append((Categories.Categories[CatKeys[indexPath.row]]?[i].RecipeName)!)
        }
        let vc = RecipeListViewController(items: Rname)
        vc.title = CategoryName
        navigationController?.pushViewController(vc,animated: true)
    }
}
