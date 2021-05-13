//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Mark Gonzalez on 3/21/21.
//

import UIKit

class RecipeViewController: UIViewController,
                            UITableViewDelegate, UITableViewDataSource,
                            UITextViewDelegate{

    var rImage: UIImage?
    var currRecipe: RecipeContainer!
    var mainMenu: ViewController!

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
// segue code
//================================================================================================

    // called when returning
    // used to reload collection view to reflect potential changes
    override func viewWillDisappear(_ animated: Bool) {
        print("TESTEST")
        mainMenu.reloadCollectionView()
    }
//================================================================================================
// table view code - custom
//================================================================================================

    //
    //               section , rows
    // name -        0       , 1
    // time -        1       , 1
    // description - 2       , 1
    // ingredients - 3       , ingredients.count + 1 for add button
    // steps -       4       , steps.count + 1 for add button
    //
    //

    var editable: Bool = false
    var addButtons: (i: UIButton, s: UIButton) = (UIButton(), UIButton())


    @objc func addRow(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        if sender.accessibilityIdentifier == "I" {
            loadIngredients.append((key: "", value: ""))
        } else {
            currRecipe.Steps.append(Tuple("", nil))
        }
        tableView.insertRows(at: [indexPath!], with: .top)
    }

    @objc func deleteRow(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        let isIngredient: Bool = sender.accessibilityIdentifier == "I"

        if isIngredient {
            loadIngredients.remove(at: indexPath!.row)
        } else {
            currRecipe.Steps.remove(at: indexPath!.row)
        }

        tableView.deleteRows(at: [indexPath!], with: .top)

        // always leaves 1 row available for editing
        if tableView.numberOfRows(inSection: indexPath!.section) == 1 {
            addRow(sender: isIngredient ? addButtons.i : addButtons.s )
        }
    }

    @objc func editButton(sender: UIBarButtonItem) {
        editable = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton))
        tableView.reloadData()
    }

    @objc func saveButton(sender: UIBarButtonItem) {
        editable = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButton))
        currRecipe.Ingredients.removeAll()
        for ingredient in loadIngredients {
            currRecipe.Ingredients[ingredient.key] = ingredient.value
        }
        tableView.reloadData()
        SaveData()
    }

    @objc func textFieldDoneEditing(_ sender: UITextField) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let index = tableView.indexPathForRow(at: point)
        switch sender.accessibilityIdentifier {
        case "I":
            switch sender.tag {
            case 100:
                guard sender.text != "" else {return}
                loadIngredients[index!.row].key = sender.text!
            case 101:
                loadIngredients[index!.row].value = sender.text!
            default:
                print("textFieldEdit error: tag:\(sender.tag)")
            }
        case "S":
            switch sender.tag {
            case 100:
                currRecipe.Steps[index!.row].instruction = sender.text!
            case 101:
                if sender.text == "" {
                    currRecipe.Steps[index!.row].duration = nil
                }
                else {
                    guard let time = Int(sender.text!) else {return}
                    currRecipe.Steps[index!.row].duration = time
                }
            default:
                print("textFieldEdit error: tag:\(sender.tag)")
            }
        default:
            print("textFieldEdit accessibilityIdetifier error")
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let point = textView.convert(CGPoint.zero, to: tableView)
        let index = tableView.indexPathForRow(at: point)
        switch index!.section {
        case 0: // name
            guard textView.text != "" else {return}
            currRecipe.RecipeName = textView.text
        case 2: // description
            currRecipe.Description = textView.text
        default:
            print("textViewEdit error")
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
            let name = cell.contentView.viewWithTag(100) as! UITextView
            name.delegate = self
            name.isEditable = editable

            // set name
            name.text = currRecipe.RecipeName
        case 1: // cooking time
            cell = tableView.dequeueReusableCell(withIdentifier: "plain", for: indexPath)
            let time = cell.contentView.viewWithTag(100) as! UITextView

            // set cooking time
            time.text = currRecipe.TotalTime
        case 2: // description
            cell = tableView.dequeueReusableCell(withIdentifier: "plain", for: indexPath)
            let description = cell.contentView.viewWithTag(100) as! UITextView
            description.delegate = self
            description.isEditable = editable

            // set description
            description.text = currRecipe.Description
        case 3: // ingredients
            if indexPath.row < loadIngredients.count {
                cell = tableView.dequeueReusableCell(withIdentifier: "step", for: indexPath)

                let ingredient = cell.contentView.viewWithTag(100) as! UITextField
                ingredient.isEnabled = editable
                ingredient.accessibilityIdentifier = "I"
                ingredient.addTarget(self, action: #selector(textFieldDoneEditing), for: .editingDidEndOnExit)
                ingredient.addTarget(self, action: #selector(textFieldDoneEditing), for: .editingDidEnd)

                let quantity = cell.contentView.viewWithTag(101) as! UITextField
                quantity.isEnabled = editable
                quantity.accessibilityIdentifier = "I"
                quantity.addTarget(self, action: #selector(textFieldDoneEditing), for: .editingDidEndOnExit)
                quantity.addTarget(self, action: #selector(textFieldDoneEditing), for: .editingDidEnd)

                let delBtn = cell.contentView.viewWithTag(102) as! UIButton
                delBtn.isHidden = !editable
                delBtn.accessibilityIdentifier = "I"
                delBtn.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)

                // set ingredient and quantity
                ingredient.text = loadIngredients[indexPath.row].key
                quantity.text = loadIngredients[indexPath.row].value
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
                instruction.isEnabled = editable
                instruction.accessibilityIdentifier = "S"
                instruction.addTarget(self, action: #selector(textFieldDoneEditing), for: .editingDidEndOnExit)
                instruction.addTarget(self, action: #selector(textFieldDoneEditing), for: .editingDidEnd)

                let duration = cell.contentView.viewWithTag(101) as! UITextField
                duration.isEnabled = editable
                duration.accessibilityIdentifier = "S"
                duration.addTarget(self, action: #selector(textFieldDoneEditing), for: .editingDidEndOnExit)
                duration.addTarget(self, action: #selector(textFieldDoneEditing), for: .editingDidEnd)

                let delBtn = cell.contentView.viewWithTag(102) as! UIButton
                delBtn.isHidden = !editable
                delBtn.accessibilityIdentifier = "S"
                delBtn.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)

                // set instruction and duration
                instruction.text = currRecipe.Steps[indexPath.row].instruction
                // set duration to "" if value is nil
                if let t = currRecipe.Steps[indexPath.row].duration {
                    duration.text = String(t)
                } else {
                    duration.text = ""
                }
            } else { // extra row for add button
                cell = tableView.dequeueReusableCell(withIdentifier: "add", for: indexPath)
                let add = cell.contentView.viewWithTag(100) as! UIButton
                add.accessibilityIdentifier = "S"
                add.addTarget(self, action: #selector(addRow), for: .touchUpInside)
                add.isHidden = !editable
                addButtons.s = add
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
