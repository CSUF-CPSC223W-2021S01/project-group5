//
//  ViewController.swift
//  RecipeApp
//
//  Created by Mark Gonzalez on 3/10/21.
//
// everything is tested with an iPhone 11 sim
// 

import UIKit

enum searchAtt: String {
    case name = "Name"
    case ingredient = "Ingredient"
    case time = "Time"
}

// for test class
/*
class TestRecipe {
    var name: String
    var image: UIImage? {
        return UIImage(named: name)
    }
    var description: String
    var ingredients: [String: String] // ingredient: quantity
    var steps: [(instruction: String, duration: Int)]
    var time: Int // in minutes
    

    init(_ name: String, is description: String, with ingredients: [String: String],
         steps: [(String, Int)], in time: Int) {
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.steps = steps
        self.time = time
    }
}

let secretFormula = ["hamburger buns": "2 buns", "mustard": "", "ketchup": "",
                     "lettuce": "1", "tomato": "2 slices", "cheese": "1 slice",
                     "pickle": "2 pieces", "onlon": "1 layer", "burger": "1 patty"]

let testRecipes: [TestRecipe] = [
    TestRecipe("burger", is: "It's a krabby patty", with: secretFormula,
               steps: [("Call spongebob", 5)], in: 5),
    TestRecipe("pancake", is: "It's pancakes", with: secretFormula,
               steps: [("Just add water", 10)], in: 10),
    TestRecipe("ramen", is: "Cup noodles", with: secretFormula,
               steps: [("Add hot water", 0), ("Wait", 3)], in: 3),
    TestRecipe("Tree 0", is: "It's an apple tree", with: secretFormula,
               steps: [("plant seed", 5), ("water", 5), ("wait 50 years", 0)], in: 0)
]
*/

var firstLoad = true
func loadTest() {
    if firstLoad {
        let secretFormula = ["hamburger buns": "2 buns", "mustard": "", "ketchup": "",
                             "lettuce": "1", "tomato": "2 slices", "cheese": "1 slice",
                             "pickle": "2 pieces", "onlon": "1 layer", "burger": "1 patty"]
        MasterList += [
            RecipeContainer("burger", "It's a krabby patty", secretFormula,
                            [Tuple("Call spongebob", 5)], "-1"),
            RecipeContainer("pancake", "It's pancakes", secretFormula,
                            [Tuple("Just add water", 10)], "-1"),
            RecipeContainer("ramen", "Cup noodles", secretFormula,
                            [Tuple("Add hot water", 0), Tuple("Wait", 3)], "-1"),
            RecipeContainer("Tree 0", "It's an apple tree", secretFormula,
                            [Tuple("plant seed", 5), Tuple("water", 5), Tuple("wait 50 years", 0)], "-1")
        ]

        firstLoad = false
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTest()
    }

//==================================================================
// Search bar code
//==================================================================
    @IBOutlet var searchDropMenuButton: UIButton!
    @IBOutlet var searchDropItem: [UIButton]!

    // var to select which attribute to search for
    var searchAttribute: searchAtt {
        return searchAtt(rawValue: searchDropMenuButton.currentTitle!) ?? searchAtt.name
    }

    // hides/unhides search drop menu items
    @IBAction func searchDropMenuPressed(_ sender: UIButton) {
        searchDropItem.forEach { (item) in
            item.isHidden = !item.isHidden
        }
    }

    // replaces search drop menu title then hides the menu items
    @IBAction func searchDropItemPressed(_ sender: UIButton) {
        searchDropMenuButton.setTitle(sender.currentTitle, for: .normal)
        searchDropMenuPressed(sender)
    }

//==================================================================
// Segue code
//==================================================================
    // generic segue to recipe view
    @IBAction func go2recipes(_ sender: Any?) {
        performSegue(withIdentifier: "mainMenu2recipeMenu", sender: sender)
    }

    // funtion that is always called when segueing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newView = segue.destination as! RecipeViewController
        switch sender {
        case is UIButton: // segue for adding a recipe
            let newRecipe = RecipeContainer("New Recipe", "", ["": ""], [Tuple("",nil)], "")
            MasterList.append(newRecipe)
            newView.currRecipe = MasterList.last
        case is IndexPath: // segue for selecting recipe
            let index = sender as! IndexPath
            newView.currRecipe = MasterList[index.row]
        default:
            print("segue failed")
        }
    }

//==================================================================
// Recipe collection view code
//==================================================================
    @IBOutlet var recipeCollectionView: UICollectionView!
    let cellSize: CGFloat = CGFloat(184.0) //X by X (good sizes are 184, 118, 52 -> 2, 3, 4 tiles)
    let tileColors: [UIColor] = [UIColor.systemRed, UIColor.systemOrange, UIColor.systemYellow,
                                 UIColor.systemGreen, UIColor.systemBlue, UIColor.systemPurple]
    
    // should return size of recipe array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MasterList.count
        // return testRecipes.count //for test class
    }

    // default function & controls cell content
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recipeCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecipeCollectionViewCell

        // create image view then fill it (size is forced to cellSize x cellSize)
        // let cellImage = testRecipes[indexPath.row].image
        // let cellView = UIImageView(frame: CGRect(x: 0, y: 0, width: cellSize, height: cellSize))
        // cellView.image = cellImage
        // cell.contentView.addSubview(cellView)

        // fill image view in storyboard if available
        if let image = UIImage(named: MasterList[indexPath.row].RecipeName) {
            let imageView = cell.contentView.subviews[0] as! UIImageView
            imageView.image = image
        }
        // image.image = testRecipes[indexPath.row].image // for test class

        cell.backgroundColor = tileColors[indexPath.row % tileColors.count]
        // ideally, the user should be able to crop an image to fit cellSize x cellSize
        return cell
    }

    // sets size of each cell (184x184, 118x118, 52x52 are good)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }

    // goes to recipe view when a cell is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //recipeCollectionView.deselectItem(at: indexPath, animated: true)
        go2recipes(indexPath)
    }

}

