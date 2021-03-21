//
//  ViewController.swift
//  RecipeApp
//
//  Created by Mark Gonzalez on 3/10/21.
//

import UIKit

enum searchAtt: String {
    case name = "Name"
    case ingredient = "Ingredient"
    case time = "Time"
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        guard sender == nil else {
            segue.destination.navigationItem.title = "New Recipe"
            return
        }

        // set navi title to selected recipe
        segue.destination.navigationItem.title = "Existing Recipe"
    }

//==================================================================
// Recipe collection view code
//==================================================================
    @IBOutlet var recipeCollectionView: UICollectionView!
    let cellSize = 184 //X by X (good sizes are 184, 118, 52 -> 2, 3, 4 tiles)

    class TestRecipe {
        var name: String
        var image: UIImage? {
            return UIImage(named: name)
        }

        init(_ name: String) {
            self.name = name
        }
    }

    let testRecipes: [TestRecipe] = [TestRecipe("burger"), TestRecipe("pancake"), TestRecipe("ramen"), TestRecipe("Tree 0")]
    
    // should return size of masterRecipes array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testRecipes.count
    }

    // default function & controls cell content
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recipeCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecipeCollectionViewCell

        let cellView = UIImageView(frame: CGRect(x: 0, y: 0, width: cellSize, height: cellSize))
        let cellImage = testRecipes[indexPath.row].image
        cellView.image = cellImage
        cell.contentView.addSubview(cellView)

        return cell
    }

    // sets size of each cell (184x184 or 130x130 are good)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }

    // goes to recipe view when a cell is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        go2recipes(nil)
    }

}

