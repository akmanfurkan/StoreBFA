//
//  BasketViewController.swift
//  StoreBFA
//
//  Created by Furkan Akman on 18.01.2023.
//

import UIKit
import JGProgressHUD

class BasketViewController: UIViewController {
    
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var checkOutButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var basketTotalPriceLabel: UILabel!
    
    //MARk: vars
    var basket: Basket?
    var allItems: [Item] = []
    var purchasedItemIds: [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    
    //MARK: View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footerView
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBasketFromFirestore()
    }
    //MARK: IBAction
    
    @IBAction func checkoutButtonPressed(_ sender: Any) {
    }
    
    //MARK: download basket
    
    private func  loadBasketFromFirestore() {
        downloadBasketFromFirestore("1234") { (basket) in
            self.basket = basket
            self.getBasketItems()
            
        }
    }
    
    func getBasketItems() {
        if basket != nil {
            downloadItems(basket!.itemIds) { (allItems )in
                self.allItems = allItems
                self.updateTotalLabels(false)
                self.tableView.reloadData()
                
            }
        }
    }
    
    //MARK: helper func
    
    private func updateTotalLabels(_ isEmpty: Bool) {
        if isEmpty {
            totalItemsLabel.text = "0"
            basketTotalPriceLabel.text = returnBasketTotalPrice()
        }else {
            basketTotalPriceLabel.text = returnBasketTotalPrice()
            
        }
    }
    
    
    private func returnBasketTotalPrice() -> String {
        
        var totalPrice = 0.0
        
        for item in allItems {
            totalPrice += item.price
            
        }
        return "Toplam fiyat:" + convertToCurrency(totalPrice)
    }
    //MARK: navigation
    private func showItemView(withItem: Item) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemView") as! ItemViewController
        itemVC.item = withItem
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    
    
    
    //MARK: control checkoutButton
    private func removeItemFromBasket(itemId:String) {
        
        for i in 0..<basket!.itemIds.count {
            if itemId == basket!.itemIds[i]{
                basket!.itemIds.remove(at: i)
                return
            }
        }
    }
    
}


extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Hucre", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(allItems[indexPath.row])
        
        return cell
    }
    
    //MARK:  tabview delagete
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath?) {
        if editingStyle == .delete {
            
            let itemToDelete = allItems[indexPath!.row]
            
            allItems.remove(at: indexPath!.row)
            tableView.reloadData()
            
            removeItemFromBasket(itemId: itemToDelete.id)
            
            updateBasketInFirestore(basket!, withValues: [kITEMIDS: basket!.itemIds]) {(error) in
                if error != nil {
                    print("error updating the basket", error!.localizedDescription)
                }
                self.getBasketItems()
            }
        }
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
    }
    
}
