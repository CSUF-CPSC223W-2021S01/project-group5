//
//  RecipeListViewController.swift
//  RecipeApp
//
//  Created by Kai Eusebio on 5/13/21.
//

import UIKit

class RecipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    var items: [String]
    var RecIndex:Int = 0
    
    init(items: [String]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        
    }
    init(items: RecipeContainer, RecIndex: Int) {
        self.items = ["INGREDIENTS"]
        for i in items.Ingredients.keys {
            self.items.append(i)
        }
        self.RecIndex = RecIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self

 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(items[indexPath.row])
        RecIndex = indexPath.row
        var RecListing = Categories.Categories[title!]?[RecIndex]
        
        guard ((RecListing ?? nil) != nil) else {
            return
        }
        let RecipeList = RecipeListViewController(items: RecListing!, RecIndex: RecIndex )
        RecipeList.title = "\(String(RecListing!.RecipeName)) @index: \(RecIndex)"
        navigationController?.pushViewController(RecipeList, animated: true)
    }

    

}
