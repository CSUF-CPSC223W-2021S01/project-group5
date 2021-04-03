//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Mark Gonzalez on 3/21/21.
//

import UIKit

class RecipeViewController: UIViewController,
                            UITableViewDelegate, UITableViewDataSource {

    var rImage: UIImage?
    var currRecipe: TestRecipe?

    // used in cell control to iterate through the dict using an index
    var loadIngredients = [(key: String, value: String)]()

    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        guard let recipe = currRecipe else {// it's a new recipe
            return
        }

        self.navigationItem.title = recipe.name

        if let image = recipe.image {
            recipeImage.image = image
        }

        for ingredient in recipe.ingredients {
            loadIngredients.append((ingredient.key, ingredient.value))
        }
        
        // Do any additional setup after loading the view.
    }

//================================================================================================
// table view code
//================================================================================================

    //
    //               sections, rows
    // name -        1, 1
    // time -        1, 1
    // description - 1, 1
    // ingredients - 1, ingredients.count
    // steps -       1, steps.count
    // Total =       5, 3 + ingredients.count + steps.count
    //
    // min of 1 row each for ingredients and steps so that
    // the user can edit the empty cell
    //
    // todo: add headers for each section
    // todo: format ingredients and steps sections
    // todo: make cells editable
    // todo: have a trailing empty cell for ingridients and steps
    //

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowArr: [Int]
        guard let recipe = currRecipe else {// new recipe
            rowArr = [1, 1, 1, 1, 1]
            return rowArr[section]
        }

        rowArr = [1, 1, 1, recipe.ingredients.count, recipe.steps.count]
        return rowArr[section]
    }

    // cell control
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        guard let recipe = currRecipe else { // new recipe
            cell.textLabel?.text = "\(indexPath.row)"
            cell.backgroundColor = .darkGray
            return cell
        }

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = recipe.name
        case 1:
            cell.textLabel?.text = "\(recipe.time) minutes"
        case 2:
            cell.textLabel?.text = recipe.description
        case 3:
            cell.textLabel?.text = "\(loadIngredients[indexPath.row].key) \t\t\t \(loadIngredients[indexPath.row].value)"
        case 4:
            cell.textLabel?.text = "\(recipe.steps[indexPath.row].instruction) \t\t\t \(recipe.steps[indexPath.row].duration) min."
        default:
            cell.textLabel?.text = "Error: \(indexPath.section), \(indexPath.row)"
        }

        return cell
    }

    // cell tapped function
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
