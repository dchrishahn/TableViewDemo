//
//  ViewController.swift
//  TableViewDemo
//
//  Created by Chris Hahn on 7/6/17.
//  Copyright © 2017 Sturnella. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

// 1 ... initial setup variable added after adding the DataItem.swift file
    var items = [DataItem]()

// 7 ... these added to start section Multiple Section to a table view
    var otherItems = [DataItem]()
    var allItems = [[DataItem]]()

// New section change ... added for another section called birds
    var birdItems = [DataItem]()
    

// 3 / 10 / 16... numberOfRowsInSection function, then changed later in Multiple Sections ... then changed in Inserting Rows section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let addedRow = isEditing ? 1 : 0
        
        return allItems[section].count + addedRow
    }

// 4 / 9 ... numberOfSections function, then changed later in Multiple Sections...

    func numberOfSections(in tableView: UITableView) -> Int {
        return allItems.count
    }

// 5 / 11 / 17 ... cellForRowAt function, then changed later in Multiple Sections ... then changed in Inserting Rows section
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.row >= allItems[indexPath.section].count && isEditing {
            cell.textLabel?.text = "Add New Item"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
        } else {
            let item = allItems[indexPath.section][indexPath.row]

//          cell.textLabel?.text = item.title[indexPath.row]
            cell.textLabel?.text = item.title
// Subtitle changes ... following line commented out
//          cell.detailTextLabel?.text = item.subtitle
        
            if let imageView = cell.imageView, let itemImage = item.image {
                imageView.image = itemImage
            } else {
                cell.imageView?.image = nil
            }
        }
        
        return cell
    }

// 12 ... titleForHeaderInSection function ... added in Multiple Sections
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section #\(section)"
    }

// 13 / 20 ... editingStyle function with commit and forRowAt ... added first in Deleting table view rows, later changed in Inserting Rows section
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            allItems[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
// Subtitle changes ... following line commented out and changed to line following which removed subtitle reference
//          let newData = DataItem(title: "New Data", subtitle: "", imageName: nil)
            let newData = DataItem(title: "New Data", imageName: nil)
            allItems[indexPath.section].append(newData)
            tableView.insertRows(at: [indexPath], with: .fade)
        }
    }

// 19 ... editingStyleForRowAt function ... added in Inserting Rows section
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let sectionItems = allItems[indexPath.section]
        if indexPath.row >= sectionItems.count {
            return .insert
        } else {
            return .delete
        }
    }

// 22 ... willSelectRowAt function ... added in Inserting Rows section
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let sectionItems = allItems[indexPath.section]
        if isEditing && indexPath.row < sectionItems.count {
            return nil
        }
        return indexPath
    }

// 23 ... didSelectRowAt function ... added in Inserting Rows section
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionItems = allItems[indexPath.section]
        if indexPath.row >= sectionItems.count && isEditing {
            self.tableView(tableView, commit: .insert, forRowAt: indexPath)
        }
    }

// 24 ... canMoveRowAt function ... added in Moving Rows section
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    let sectionItems = allItems[indexPath.section]
    if indexPath.row >= sectionItems.count && isEditing {
    return false
    }
    return true
    }
    
// 25 ...  moveRowAt override function ... added in Moving Rows section !!!! generates error !!!! tableView not in class base, thus override is not necessary
//
// tutor said ... UIViewControllers don’t have a function called `moveRowAtIndexPath`.  UITableViewController is a subclass of UIViewcontroller and it has that function
// built in by default
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = allItems[sourceIndexPath.section][sourceIndexPath.row]
        
        allItems[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        
        if sourceIndexPath.section == destinationIndexPath.section {
            allItems[sourceIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)
        } else {
            allItems[destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)
        }
    }
    
// 26 ... targetIndexPathForMoveFromRowAt function ... added in Moving Rows section
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let sectionItems = allItems[proposedDestinationIndexPath.section]
        if proposedDestinationIndexPath.row >= sectionItems.count {
            return IndexPath(row: sectionItems.count - 1, section: proposedDestinationIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
// 15 / 18 ... setEditing override function ... added in the Deleting table view rows section, later changed in Inserting Rows section
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            tableView.beginUpdates()
            
            for (index, sectionItems) in allItems.enumerated() {
                let indexPath = IndexPath(row: sectionItems.count, section: index)
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
            tableView.endUpdates()
            tableView.setEditing(true, animated: true)
        } else {
            tableView.beginUpdates()
            
            for (index, sectionItems) in allItems.enumerated() {
                let indexPath = IndexPath(row: sectionItems.count, section: index)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            tableView.endUpdates()
            tableView.setEditing(false, animated: true)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

// 2 ... for loops added for images; "img" one added first ...
        
        for i in 1...12 {
            if i > 9 {
// Subtitle changes ... following line commented out and changed to following line which removes subtitle references
//              items.append(DataItem(title: "Title #\(i)", subtitle: "This is subtitle #\(i)", imageName: "images/img\(i).jpg"))
                items.append(DataItem(title: "Land & plant image \(i)", imageName: "images/img\(i).jpg"))
            } else {
// Subtitle changes ... following line commented out and changed to following line which removes subtitle references
//              items.append(DataItem(title: "Title #0\(i)", subtitle: "This is subtitle #0\(i)", imageName: "images/img0\(i).jpg"))
                items.append(DataItem(title: "Land & plant image 0\(i)", imageName: "images/img0\(i).jpg"))
            }
        }

// 8 ... for loops added for images; "anim" added later, in the Multiple Sections portion; included the following 2 allItems statements ...
        
        for i in 1...10 {
            if i > 9 {
// Subtitle changes ... following line commented out and changed to following line which removes subtitle references
//              otherItems.append(DataItem(title: "Another Title #\(i)", subtitle: "This is another subtitle #\(i)", imageName: "images/anim\(i).jpg"))
                otherItems.append(DataItem(title: "Mammal image \(i)", imageName: "images/anim\(i).jpg"))
            } else {
// Subtitle changes ... following line commented out and changed to following line which removes subtitle references
//              otherItems.append(DataItem(title: "Another Title #0\(i)", subtitle: "This is another subtitle #0\(i)", imageName: "images/anim0\(i).jpg"))
                otherItems.append(DataItem(title: "Mammal image 0\(i)", imageName: "images/anim0\(i).jpg"))
            }
        }
        
// New section change ... added for another section of birds ... two animx.jpg's changed to birdx.jpg names, all animx.jpg's renamed sequentially
        
        for i in 1...2 {
            if i > 9 {
                // Subtitle changes ... following line commented out and changed to following line which removes subtitle references
                //              otherItems.append(DataItem(title: "Another Title #\(i)", subtitle: "This is another subtitle #\(i)", imageName: "images/anim\(i).jpg"))
                birdItems.append(DataItem(title: "Bird image \(i)", imageName: "images/bird\(i).jpg"))
            } else {
                // Subtitle changes ... following line commented out and changed to following line which removes subtitle references
                //              otherItems.append(DataItem(title: "Another Title #0\(i)", subtitle: "This is another subtitle #0\(i)", imageName: "images/anim0\(i).jpg"))
                birdItems.append(DataItem(title: "Bird image 0\(i)", imageName: "images/bird0\(i).jpg"))
            }
        }
        
        allItems.append(items)
        allItems.append(otherItems)
        
// New section change ... added for another section of birds
        allItems.append(birdItems)

// 6 ... resize scroll view insets ...
        automaticallyAdjustsScrollViewInsets = false

// 14 ... added in Deleting table view rows section ...
        navigationItem.rightBarButtonItem = editButtonItem

// 21 ... added in Inserting Rows section ...
        tableView.allowsSelectionDuringEditing = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

