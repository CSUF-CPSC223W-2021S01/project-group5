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
    var currRecipe: RecipeContainer!

    // used in tableView() to iterate through the dict using an index
    var loadIngredients = [(key: String, value: String)]()

    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        self.navigationItem.title = currRecipe.RecipeName
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButton))

        if let image = UIImage(named: currRecipe.RecipeName) {
            recipeImage.image = image
        }

        for ingredient in currRecipe.Ingredients {
            loadIngredients.append((ingredient.key, ingredient.value))
        }
    }

//================================================================================================
// table view code - custom
//================================================================================================

    //
    //               section , rows
    // name -        0       , 1
    // time -        1       , 1
    // description - 2       , 1
    // ingredients - 3       , ingredients.count + 1
    // steps -       4       , steps.count + 1
    //
    // todo: add headers for each section
    // todo: delete button should only delete after saving
    //

    var editable: Bool = false
    var addButtons: (i: UIButton, s: UIButton) = (UIButton(), UIButton())

    var indices = [(IndexPath, Any)]()
    // use: stores index path and contents of all cells. "Any" can be UITextView or (UITextField, UITextField, UIButton)
    //
    // problems: indices sometimes retains useless data after removing an element
    // solution: don't use indicies
    //
    // use case 1: updating editability of cells
    // replacement 1: use tableView.reloadData() in editButton() after changing editable
    //
    // use case 2: saving
    // replacement 1: go through every cell with tableView
    // replacement 2: somehow save immediately after editing


    @objc func addRow(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        if sender.accessibilityIdentifier == "I" {
            loadIngredients.append((key: "", value: ""))
        } else {
            currRecipe.Steps.append(Tuple("", nil))
        }
        tableView.insertRows(at: [indexPath!], with: .top)
        if let cell = tableView.cellForRow(at: indexPath!) {
            let field1 = cell.contentView.viewWithTag(100) as! UITextField
            let field2 = cell.contentView.viewWithTag(101) as! UITextField
            let field3 = cell.contentView.viewWithTag(102) as! UIButton
            field1.isEnabled = editable
            field2.isEnabled = editable
            field3.isHidden = !editable
            field3.accessibilityIdentifier = sender.accessibilityIdentifier
            // print("inserting at \(indexPath!.row):\(indexPath!.section)")
            indices.append((indexPath!, (field1, field2, field3)))
        }
    }

    @objc func deleteRow(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        let isIngredient: Bool = sender.accessibilityIdentifier == "I"

        guard let oldIndex = indices.firstIndex(where: { index, _ in
            // print("\(index.row), \(index.section) : \(indexPath!.row), \(indexPath!.section)")
            return index == indexPath!
        }) else {
            print("Error: deleteRow() guard broken. aborting delete.")
            return
        }

        if isIngredient {
            loadIngredients.remove(at: indexPath!.row)
        } else {
            currRecipe.Steps.remove(at: indexPath!.row)
        }

        // print("removing at \(indexPath!.row):\(indexPath!.section) and \(oldIndex)")
        // print()

        indices.remove(at: oldIndex)
        tableView.deleteRows(at: [indexPath!], with: .top)

        if tableView.numberOfRows(inSection: indexPath!.section) == 1 {
            addRow(sender: isIngredient ? addButtons.i : addButtons.s )
        }
    }

    @objc func editButton(sender: UIBarButtonItem) {
        editable = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton))
        walkIndices()
        addButtons.i.isHidden = false
        addButtons.s.isHidden = false
    }

    @objc func saveButton(sender: UIBarButtonItem) {
        editable = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButton))
        walkIndices()
        addButtons.i.isHidden = true
        addButtons.s.isHidden = true
        SaveData()
    }

    func walkIndices() {
        // index is an IndexPath
        // cell is whatever the content of the cell was. (stored in a tuple if a cell has more than one item)
        for (index, cell) in indices {
            switch index.section {
            case 0:
                let row = cell as! UITextView
                if !editable { // is saving
                    currRecipe.RecipeName = row.text
                }
                row.isEditable = editable
            case 1:
                print("total time")
                /*
                let row = cell as! UITextView
                if !editable { // is saving
                    currRecipe.TotalTime = Int(row.text)
                }
                row.isEditable = editable
                */
            case 2:
                let row = cell as! UITextView
                if !editable { // is saving
                    currRecipe.Description = row.text
                }
                row.isEditable = editable
            case 3:
                let row = cell as! (UITextField, UITextField, UIButton)
                let ingredient = row.0
                let quantity = row.1
                let btn = row.2
                if !editable { // is saving
                    currRecipe.Ingredients.removeValue(forKey: loadIngredients[index.row].key)
                    currRecipe.Ingredients[ingredient.text!] = quantity.text!
                    loadIngredients[index.row] = (ingredient.text!, quantity.text!)
                }
                ingredient.isEnabled = editable
                quantity.isEnabled = editable
                btn.isHidden = !editable // false if editing
            case 4:
                let row = cell as! (UITextField, UITextField, UIButton)
                let step = row.0
                let duration = row.1
                let btn = row.2
                if !editable { // is saving
                    if duration.text != "" {
                        currRecipe.Steps[index.row] = Tuple(step.text!, Int(duration.text!))
                    } else {
                        currRecipe.Steps[index.row] = Tuple(step.text!, nil)
                    }
                }
                step.isEnabled = editable
                duration.isEnabled = editable
                btn.isHidden = !editable // false if editing
            default:
                print("error: indices: \(index.section), \(index.row), \(editable)")
            }
        }
    }
//================================================================================================
// table view code - default
//================================================================================================
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowArr: [Int]
        rowArr = [1, 1, 1, loadIngredients.count + 1, currRecipe.Steps.count + 1]
        return rowArr[section]
    }

    // section headers
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Recipe Name"
        case 1:
            return "Cooking Time"
        case 2:
            return "Description"
        case 3:
            return "Ingredients"
        case 4:
            return "Steps"
        default:
            return "ERROR"
        }
    }

    // initial cell loading (cells not shown on the screen are not considered loaded)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell

        switch indexPath.section {
        case 0: // name
            cell = tableView.dequeueReusableCell(withIdentifier: "plain", for: indexPath)
            let text = cell.contentView.viewWithTag(100) as! UITextView
            text.text = currRecipe.RecipeName
            indices.append((indexPath, text))
        case 1: // cooking time
            cell = tableView.dequeueReusableCell(withIdentifier: "plain", for: indexPath)
            let text = cell.contentView.viewWithTag(100) as! UITextView
            text.text = currRecipe.TotalTime
            indices.append((indexPath, text))
        case 2: // description
            cell = tableView.dequeueReusableCell(withIdentifier: "plain", for: indexPath)
            let text = cell.contentView.viewWithTag(100) as! UITextView
            text.text = currRecipe.Description
            indices.append((indexPath, text))
        case 3: // ingredients
            if indexPath.row < loadIngredients.count {
                cell = tableView.dequeueReusableCell(withIdentifier: "step", for: indexPath)
                let ingredient = cell.contentView.viewWithTag(100) as! UITextField
                let quantity = cell.contentView.viewWithTag(101) as! UITextField
                let delBtn = cell.contentView.viewWithTag(102) as! UIButton

                ingredient.text = loadIngredients[indexPath.row].key
                quantity.text = loadIngredients[indexPath.row].value
                delBtn.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)

                indices.append((indexPath, (ingredient, quantity, delBtn)))
            } else { // extra row for add button
                cell = tableView.dequeueReusableCell(withIdentifier: "add", for: indexPath)
                let add = cell.contentView.viewWithTag(100) as! UIButton
                add.isHidden = !editable
                addButtons.i = add
                add.accessibilityIdentifier = "I"
                add.addTarget(self, action: #selector(addRow), for: .touchUpInside)
            }
        case 4: // steps
            if indexPath.row < currRecipe.Steps.count {
                cell = tableView.dequeueReusableCell(withIdentifier: "step", for: indexPath)
                let instruction = cell.contentView.viewWithTag(100) as! UITextField
                let duration = cell.contentView.viewWithTag(101) as! UITextField
                let delBtn = cell.contentView.viewWithTag(102) as! UIButton

                instruction.text = currRecipe.Steps[indexPath.row].instruction
                if let t = currRecipe.Steps[indexPath.row].duration {
                    duration.text = String(t)
                } else {
                    duration.text = ""
                }
                delBtn.accessibilityIdentifier = "S"
                delBtn.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)

                indices.append((indexPath, (instruction, duration, delBtn)))
            } else { // extra row for add button
                cell = tableView.dequeueReusableCell(withIdentifier: "add", for: indexPath)
                let add = cell.contentView.viewWithTag(100) as! UIButton
                add.isHidden = !editable
                addButtons.s = add
                add.accessibilityIdentifier = "S"
                add.addTarget(self, action: #selector(addRow), for: .touchUpInside)
            }
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "plain", for: indexPath)
            let text = cell.contentView.viewWithTag(100) as! UITextView
            text.text = "Error: \(indexPath.section), \(indexPath.row)"
            text.isEditable = false
        }
        return cell
    }

    // cell tapped function
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
