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
        SaveData()
        firstLoad = false
    }
}

class ViewController: UIViewController,
                      UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var displayList: [RecipeContainer]!

    override func viewDidLoad() {
        super.viewDidLoad()
        if LoadData() { print("Load successful") }
        else {
            print("Loading failed... Starting loadTest()")
            loadTest()
        }
        displayList = MasterList
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

    // calls a search function to replace the displayed list of recipes
    @IBAction func searchValueChanged(_ sender: UITextField) {
        guard let text = sender.text, text != "" else {
            displayList = MasterList
            recipeCollectionView.reloadData()
            return
        }

        let found = searchRecipe(searchAttribute, text)
        guard !found.isEmpty else { return }
        displayList = found
        recipeCollectionView.reloadData()
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
        newView.mainMenu = self
        switch sender {
        case is UIButton: // segue for adding a recipe
            let newRecipe = RecipeContainer("New Recipe", "", ["": ""], [Tuple("",nil)], "")
            MasterList.append(newRecipe)
            newView.currRecipe = MasterList.last
        case is IndexPath: // segue for selecting recipe
            let index = sender as! IndexPath
            newView.currRecipe = displayList[index.row]
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
        return displayList.count
    }

    // default function & controls cell content
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // fill image view in storyboard if available
        let cell: UICollectionViewCell
        if let image = UIImage(named: displayList[indexPath.row].RecipeName) {
            cell = recipeCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let imageView = cell.contentView.subviews[0] as! UIImageView
            imageView.image = image
        } else {
            // display the recipe's name
            cell = recipeCollectionView.dequeueReusableCell(withReuseIdentifier: "plain", for: indexPath)
            let nameLabel = cell.contentView.subviews[0] as! UILabel
            nameLabel.textAlignment = .center
            nameLabel.textColor = .white
            nameLabel.text = displayList[indexPath.row].RecipeName
        }

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

    // called from RecipeViewController.swift when returning to this menu
    func reloadCollectionView() {
        recipeCollectionView.reloadData()
    }
    
    
    
}

