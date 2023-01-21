//
//  ItemsTableViewController.swift
//  StoreBFA
//
//  Created by Furkan Akman on 17.01.2023.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    //MARK: Vars
    var category: Category!
    
    var itemArray: [Item] = []
    
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("we have selected", category?.name)
        
        tableView.tableFooterView = UIView()
        self.title = category?.name
        
        loadItems()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil {
            //download items
        }
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Hucre", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(itemArray[indexPath.row])


        return cell
    }
    ///: Tableview delaget
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(itemArray[indexPath.row])
        
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemToAddItemSeg" {
            let vc = segue.destination as! AddItemViewController
            vc.category = category!
            
        }

    }
    private func showItemView(_ item: Item){
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemView") as! ItemViewController
        itemVC.item = item
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    //MARK: Load Items
    private func loadItems() {
        downloadItemsFromFirebase(withCategoryId: category!.id) { (allItem) in
            print("we have \(allItem.count) items for this category")
            self.itemArray = allItem
            self.tableView.reloadData()
        }
        
    }
 

}
